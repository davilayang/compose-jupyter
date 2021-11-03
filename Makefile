# /bin/bash

USER_NAME = $(USER)
CURRENT_DIR = $(PWD)

# build the jupyter image
build: 
	docker build --tag local/jupyter \
		--build-arg USER_NAME=$(USER_NAME) \
		--build-arg COLOR_THEME=dracula \
		.

# start the jupyter server
start: 
	docker run -it --rm \
	    --name jupyter-on-docker \
	    --volume $(CURRENT_DIR)/notebooks:/app/notebooks \
	    --volume $(CURRENT_DIR)/data:/app/data \
	    --publish 8888:8888 \
	    local/jupyter

# start the jupyter server in detached mode
start-detach: 
	docker run -it --rm --detach \
	    --name jupyter-on-docker \
	    --volume $(CURRENT_DIR)/notebooks:/app/notebooks \
	    --volume $(CURRENT_DIR)/data:/app/data \
	    --publish 8888:8888 \
	    local/jupyter

# stop the running server
stop: 
	docker stop jupyter-on-docker
