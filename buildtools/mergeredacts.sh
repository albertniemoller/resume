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

# echoing "" after catting is a hacky way to ensure we have a newline so everything gets read
( cat $INPUT_FILE; echo "") | \
    while read LINE; do
        if $(echo $LINE | fgrep -q $SUBST_TOKEN); then
            cat $REDACT_FILE
            echo "" 
        else
            echo $LINE
        fi
    done > $OUTPUT_FILE