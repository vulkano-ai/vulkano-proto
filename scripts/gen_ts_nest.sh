#!/bin/sh

rm -rf src/nest/"$1" || true

protoc --experimental_allow_proto3_optional \
        --plugin=node_modules/.bin/protoc-gen-ts_proto \
        -I=proto/ \
        --ts_proto_out=src/nest/ \
        --ts_proto_opt=stringEnums=true \
        --ts_proto_opt=nestJs=true \
        --ts_proto_opt=esModuleInterop=true \
        --ts_proto_opt=exportCommonSymbols=false \
        --ts_proto_opt=useDate=true \
        proto/"$1"/"$1".proto

./scripts/gen_exports.sh src/nest/"$1"