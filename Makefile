# /bin/bash

USER_NAME = $(USER)
CURRENT_DIR = $(PWD)

# build the jupyter image
build: 
	docker build -t jupyter --build-arg USER_NAME=$(USER_NAME) .

# start the jupyter server
start: 
	docker run -it --rm \
	    --volume $(CURRENT_DIR)/notebooks:/app/notebooks \
	    --volume $(CURRENT_DIR)/data:/app/data \
	    --publish 8888:8888 \
	    jupyter

# start the jupyter server in detached mode
start-detach: 
	docker run -it --rm --detach \
	    --volume $(CURRENT_DIR)/notebooks:/app/notebooks \
	    --volume $(CURRENT_DIR)/data:/app/data \
	    --publish 8888:8888 \
	    jupyter
