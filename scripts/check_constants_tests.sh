#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage:"
  echo "  $0 --staged               # check staged changes (for pre-commit)"
  echo "  $0 --diff-base <ref>      # check diff between <ref> and HEAD (for CI)"
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

MODE="$1"
BASE_REF="${2-}"

case "$MODE" in
  --staged)
    CHANGED_FILES="$(git diff --cached --name-only)"
    ;;
  --diff-base)
    if [ -z "$BASE_REF" ]; then
      echo "ERROR: --diff-base requires a base ref argument (e.g. origin/main)." >&2
      usage
      exit 1
    fi
    CHANGED_FILES="$(git diff --name-only "$BASE_REF"...HEAD)"
    ;;
  *)
    echo "ERROR: unknown mode: $MODE" >&2
    usage
    exit 1
    ;;
esac

# Find all relevant *Constants.cls files (excluding *ConstantsTest.cls)
CONSTANTS_FILES=$(echo "$CHANGED_FILES" | grep 'Constants\.cls$' | grep -v 'ConstantsTest\.cls$' || true)

if [ -z "$CONSTANTS_FILES" ]; then
  echo "No *Constants.cls changes detected."
  exit 0
fi

MISSING_TESTS=""

for FILE in $CONSTANTS_FILES; do
  DIR=${FILE%/*}
  BASENAME=${FILE##*/}
  PREFIX=${BASENAME%Constants.cls}
  EXPECTED_TEST_FILE="$DIR/${PREFIX}ConstantsTest.cls"

  if ! echo "$CHANGED_FILES" | grep -qx "$EXPECTED_TEST_FILE"; then
    MISSING_TESTS="${MISSING_TESTS}\n- $FILE (expected test: $EXPECTED_TEST_FILE)"
  fi
done

if [ -n "$MISSING_TESTS" ]; then
  echo "ERROR: The following *Constants.cls classes are changed without corresponding *ConstantsTest.cls test classes:"
  # shellcheck disable=SC2059
  printf "%b\n" "$MISSING_TESTS"
  echo "Please add/update the corresponding *ConstantsTest.cls test classes."
  exit 1
fi

echo "All *Constants.cls changes have corresponding *ConstantsTest.cls tests."