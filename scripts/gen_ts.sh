#!/bin/sh

rm -rf src/ts/"$1" || true

protoc --experimental_allow_proto3_optional \
        --plugin=node_modules/.bin/protoc-gen-ts_proto \
        -I=proto/ \
        --ts_proto_out=src/ts \
        --ts_proto_opt=stringEnums=true \
        --ts_proto_opt=esModuleInterop=true \
        --ts_proto_opt=exportCommonSymbols=false \
        proto/"$1"/"$1".proto

./scripts/gen_exports.sh src/ts/"$1"