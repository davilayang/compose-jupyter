# Jupyter Lab on Docker

Starts a Jupyter Lab Server with Docker

## Build the `local/jupyter` Images

Before building the image, add the required PYPI dependencies in `requirements.txt`. 

Then, use the predefined Make rules to build the Docker images

```bash
make build-basic TAG=pandas 
# builds a image with tag local/jupyter:pandas

make build-pyspark
# builds a image with tag local/jupyter:pyspark

make build-tensorflow
# builds a image with tag local/jupyter:tensorflow
```

Additional configurations to images can be set in `docker-compose.yaml`. E.g. different version of Python, color theme for Jupyter ...etc

## Start Jupyter Server

### In this repository

Use `docker compose up` to start the service

```bash
docker compose up
# build and start with local/jupyter:latest image
```

### In any working directory

Start Jupyter server and mount current working directory to running container at `/app`, i.e. the root directory of Jupyter Server. Using any of the following approach will do.

1. Add function `jupyterHere`

```bash
function jupyterHere () {

    # showh help message
    if [[ ( $1 == "--help" ) || ( $1 == "-h" ) ]] ; then

        echo "       " 
        echo "Usage:   jupyterHere  IMAGE-TAG" 
        echo "       " 
        echo "Start a Jupyter Server in Current Working Directory."
        echo "Works with image built by project 'compose-jupyter'." 
        echo "       " 
        echo "Examples: " 
        echo "  - Run 'jupyterHere latest' to start a server with default image"
        echo "  - Run 'jupyterHere rdflib' to start a server with rdflib image"
        echo "       " 
        
        return 1

    elif [[ ( $# -eq 0 ) ]] ; then

        
        echo "       " 
        echo "List all available local/jupyter images on this machine:"
        echo "       "
        docker image ls local/jupyter

        echo "       " 
        echo "Run 'jupyterHere -h' for more information on usage."

    else

        echo "Visit http://127.0.0.1:8888/lab on browser to use Jupyter Lab"
        local image_tag="${1:-latest}" ; # default to tag "latest"

        docker run -it --rm -v $PWD:/app -p 8888:8888 local/jupyter:$image_tag ;

    fi
}
```

2. Call function with image tag to start Jupyter server

```bash
jupyterHere pandas
# start with the image local/jupyter:pandas
```

## Access Jupyter Server

With Chrome in headless mode: 

```bash
google-chrome --incognito --app=http://localhost:8888/lab
google-chrome --new-window --app=http://localhost:8888/lab
```

With any other browser, go to http://localhost:8888/lab

## Notes

Manage `requirements.txt` using `git stash`.  

+ `git stash push -m "some-comment"`, to stash changes with a comment
+ `git stash list`, to show all stashes and their number
+ `git stash pop stash@{number}`, to pop the stashed changes
+ then, `make build-basic TAG=<tag-name>` to build a image
