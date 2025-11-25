#!/bin/bash

# Color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${BLUE}=== NetRecon Linux Test Runner ===${RESET}"
echo ""

TEST_DIR="./tests/linux"
TOTAL=0
PASSED=0
FAILED=0

# Recursively discover all *.sh tests under tests/linux
find "$TEST_DIR" -type f -name "*.sh" ! -name "run_all_tests.sh" ! -path "*/utils/*" | while read -r test_file; do
	TOTAL=$((TOTAL+1))
	echo -e "${YELLOW}→ Running test: ${test_file}${RESET}"
	
	bash "$test_file"
	EXIT_CODE=$?

	if [ $EXIT_CODE -eq 0 ]; then
		echo -e "${GREEN}✔ PASS: ${test_file}${RESET}"
		PASSED=$((PASSED+1))
	else
		echo -e "${RED}✘ FAIL: ${test_file}${RESET}"
		FAILED=$((FAILED+1))
	fi
	
	echo ""
done

echo -e "${BLUE}=== Test Summary ===${RESET}"
echo -e "Total: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${RESET}"
echo -e "${RED}Failed: $FAILED${RESET}"

if [ $FAILED -eq 0 ]; then
	exit 0
else
	exit 1
fi
