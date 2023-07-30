#!/bin/bash

# Invoke with args InputFilePath, OutputDir, TmpDir

IN_FILE=$1
OUT_DIR=$2
TMP_DIR=$3

if [ -z "$IN_FILE" -o -z "$OUT_DIR" -o -z "$TMP_DIR" ]; then 
    echo "args: InputFilePath OutputDirPath TmpDirPth" >&2
    exit 1
fi

set -e
set -x

# inspired by https://learnbyexample.github.io/customizing-pandoc/

# This is ugly but this is the best way I've figured to get my contact info
# table left aligned rather than centered. As a nice side effect it generates a
# tex file that I can use to debug

FILE_NAME_BASE=$(basename $IN_FILE | sed 's/.md//g')
TMP_FILE_NAME=${FILE_NAME_BASE}.tex
TMP_FILE_PATH=$TMP_DIR/$TMP_FILE_NAME

pandoc $IN_FILE \
    --standalone \
    -V geometry:margin=2cm \
    -o $TMP_FILE_PATH

perl -i -pe 's/\[c\]/\[l\]/' $TMP_FILE_PATH

pushd $TMP_DIR
lualatex $TMP_FILE_NAME
popd

mv $TMP_DIR/$FILE_NAME_BASE.pdf $OUT_DIR/