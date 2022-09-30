# /bin/bash

USER_NAME := $(USER)
USER_UID := $(shell id -u $(USER))

# crate required envs
env:
	echo "USER_UID=$(USER_UID) \nUSER_NAME=$(USER_NAME)" > .env

# build the jupyter images
build-basic: 
	docker compose build basic \
	&& docker tag local/jupyter:latest local/jupyter:$(TAG)

build-pysaprk: 
	docker compose build pyspark

build-tensorflow: 
	docker compose build tensorflow
