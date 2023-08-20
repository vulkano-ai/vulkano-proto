#!/bin/sh

rm -rf src/py/inference/"$1" || true
mkdir -p src/py/inference/"$1"
protoc --experimental_allow_proto3_optional \
        -I=proto/ \
        --python_out=src/py/inference/ \
        proto/"$1".proto

cp proto/"$1".proto src/py/inference/"$1".proto
touch src/py/inference/"$1"/__init__.py
touch src/py/inference/__init__.py

