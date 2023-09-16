PROJECT_NAME := "inference"


define gen_python
	rm -rf src/py/$(PROJECT_NAME)/$(1)
	mkdir -p src/py/$(PROJECT_NAME)/$(1)
	protoc -I=proto --python_out=src/py/$(PROJECT_NAME)/ proto/$(1)/*.proto
	cp -r proto/$(1)/* src/py/$(PROJECT_NAME)/$(1)
	touch src/py/$(PROJECT_NAME)/$(1)/__init__.py
	touch src/py/$(PROJECT_NAME)/__init__.py
	echo "from .$(1) import *" >> src/py/$(PROJECT_NAME)/__init__.py
endef

define protoc_nest
	protoc --experimental_allow_proto3_optional \
        --plugin=node_modules/.bin/protoc-gen-ts_proto \
        -I=proto/ \
        --ts_proto_out=src/nest/ \
        --ts_proto_opt=stringEnums=true \
        --ts_proto_opt=nestJs=true \
        --ts_proto_opt=esModuleInterop=true \
        --ts_proto_opt=exportCommonSymbols=false \
        --ts_proto_opt=useDate=true \
        proto/"$(1)"/"$(1)".proto
endef

define protoc_ts
	protoc --experimental_allow_proto3_optional \
        --plugin=node_modules/.bin/protoc-gen-ts_proto \
        -I=proto/ \
        --ts_proto_out=src/ts \
        --ts_proto_opt=stringEnums=true \
        --ts_proto_opt=esModuleInterop=true \
        --ts_proto_opt=exportCommonSymbols=false \
        proto/"$(1)"/"$(1)".proto
endef


define gen_nest
	rm -rf src/nest/$(1)
	mkdir -p src/nest/$(1)
	$(call protoc_nest,$(1))
	./scripts/gen_exports.sh src/nest/"$(1)"
	cat src/nest/$(1)/index.ts
endef


define gen_ts
	rm -rf src/ts/$(1)
	mkdir -p src/ts/$(1)
	$(call protoc_ts,$(1))
	./scripts/gen_exports.sh src/ts/"$(1)"
	cat src/ts/$(1)/index.ts
endef


init-node:
	npm install

init-python:
	pip install -r requirements.txt

all: python node


clean-python:
	rm -rf src/py

clean-node:
	rm -rf src/ts
	rm -rf src/nest
	rm -rf lib/

clean: clean-python clean-node
	rm -rf src/

python: clean-python 
	@$(call gen_python,pipeline)
	@$(call gen_python,providers)



node-ts:
	@$(call gen_ts,pipeline)
	@$(call gen_ts,providers)

node-nest:
	@$(call gen_nest,pipeline)
	@$(call gen_nest,providers)

node: clean-node node-ts node-nest
	./scripts/gen_exports.sh src/nest
	./scripts/gen_exports.sh src/ts
	npm run build