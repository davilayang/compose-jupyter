# /bin/bash

USER_NAME := $(USER)
WORKING_DIRECTORY := $(PWD)
THEME := dracula # jupyter lab color theme 
TAG := latest # docker image tag

# build the jupyter image
build: 
	docker build --tag local/jupyter:$(TAG) \
		--build-arg USER_NAME=$(USER_NAME) \
		--build-arg COLOR_THEME=$(THEME) \
		.

# start the jupyter server
start: 
	docker run -it --rm \
	    --name jupyter-on-docker \
	    --volume $(WORKING_DIRECTORY)/notebooks:/app/notebooks \
	    --volume $(WORKING_DIRECTORY)/data:/app/data \
	    --publish 8888:8888 \
	    local/jupyter:$(TAG)

# start the jupyter server in detached mode
start-detach: 
	docker run -it --rm --detach \
	    --name jupyter-on-docker \
	    --volume $(WORKING_DIRECTORY)/notebooks:/app/notebooks \
	    --volume $(WORKING_DIRECTORY)/data:/app/data \
	    --publish 8888:8888 \
	    local/jupyter:$(TAG)

# stop the running server
stop: 
	docker stop jupyter-on-docker
