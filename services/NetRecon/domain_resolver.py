import socket
from urllib.parse import urlparse

import requests
from bs4 import BeautifulSoup

def _normalize_domain(value: str | None) -> str | None:
	"""Normalize a URL or hostname to a bare domain (e.g. https://www.ovhcloud.com -> ovhcloud.com)."""
	if not value:
		return None

	value = value.strip()
	if not value:
		return None

	# If there is no scheme, prepend one so urlparse can handle it
	if "://" not in value:
		value = "http://" + value

	parsed = urlparse(value)
	host = parsed.hostname or parsed.path
	if not host:
		return None

	# Strip common "www." prefix
	if host.startswith("www."):
		host = host[4:]

	return host.lower()

def _fetch_peeringdb_website_html(asn: int) -> str | None:
	"""Fetch website URL from PeeringDB HTML page for a given ASN."""
	url = f"https://www.peeringdb.com/asn/{asn}"
	try:
		resp = requests.get(url, timeout=5)
	except Exception as e:
		print(f"[!] PeeringDB request failed for ASN {asn}: {e}")
		return None

	if resp.status_code != 200:
		print(f"[-] PeeringDB returned status {resp.status_code} for ASN {asn}")
		return None

	try:
		soup = BeautifulSoup(resp.text, "html.parser")
	except Exception as e:
		print(f"[!] Failed to parse PeeringDB HTML for ASN {asn}: {e}")
		return None

	# This is based on current PeeringDB markup and may break if the site changes.
	div = soup.find(
		"div",
		{
			"class": "view_value col-8 col-sm-7 col-md-8",
			"data-edit-name": "website",
		},
	)
	if not div:
		return None

	a = div.find("a")
	href = None
	if a:
		href = a.get("href") or a.get_text(strip=True)
	else:
		href = div.get_text(strip=True)

	return href or None