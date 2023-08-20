#!/bin/sh -e

mkdir -p src/ts
mkdir -p src/nest

for var in "$@"
do
    ./scripts/gen_ts.sh $var
    ./scripts/gen_ts_nest.sh $var
done

./scripts/gen_exports.sh src/nest
./scripts/gen_exports.sh src/ts
