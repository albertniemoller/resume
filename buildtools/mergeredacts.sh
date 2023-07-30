#!/bin/bash

INPUT_FILE=$1
REDACT_FILE=$2
OUTPUT_FILE=$3
SUBST_TOKEN=$4

if [ -z "$INPUT_FILE" -o -z "$REDACT_FILE" -o -z "$OUTPUT_FILE" -o -z "$SUBST_TOKEN" ]; then
    echo "args: inputfile redactfile outputfile substtoken" >&2
    exit 1
fi

set -e

cat $INPUT_FILE | \
    while read LINE; do
        if $(echo $LINE | fgrep -q $SUBST_TOKEN); then
            cat $REDACT_FILE

            # not sure what's going on here but we're dropping a newline so adding it back. Dig into this if we ever start having extra newlines.
            echo ""
        else
            echo $LINE
        fi
    done > $OUTPUT_FILE
