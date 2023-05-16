# Jupyter Lab on Docker

Starts a Jupyter Lab Server with Docker

## Build the `local/jupyter` Images

Before building, add the required PYPI dependencies to local text file "requirements.txt". Alternatively, create a text file with prefix "req-" or "requirements-" and add the required dependencies.

Then, use the predefined Make rules to build the Docker images

```bash
make build-basic TAG=pandas  REQ=requirements-colab.txt
# builds a image with tag local/jupyter:pandas 
# using pip requirements in "requirements-colab.txt"

make build-pyspark
# builds a image with tag local/jupyter:pyspark
# using default pip requirements in "requirements.txt"

make build-tensorflow
# builds a image with tag local/jupyter:tensorflow
```

Additional configurations to images can be set in `docker-compose.yaml`. E.g. different version of Python, server user name ...etc

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

    # show help message
    if [[ ( $1 == "--help" ) || ( $1 == "-h" ) ]] ; then

        echo "       " 
        echo "Usage:  "
        echo "  - \"jupyterHere  <IMAGE-TAG>\""
        echo "       " 
        echo "Start a Jupyter Lab Server in current working directory; using images built by project 'compose-jupyter'." 
        echo "Current working directory is mounted at \"/app\" in the container. " 
        echo "       " 
        echo "Examples: " 
        echo "  - Run \"jupyterHere latest\" to start a server with default local/jupyter:latest image at localhost:8888"
        echo "  - Run \"jupyterHere colab 8890\" to start a server with local/jupyter:colab image at localhost:8890"
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

        local image_tag="${1:-latest}" ; # default to tag "latest"
        local port="${2:-8888}" ; # default to port "8888"
        echo "Visit http://127.0.0.1:$port/lab on browser to use Jupyter Lab"

        docker run -it --rm -v $PWD:/app -p $port:8888 local/jupyter:$image_tag ;

    fi
}
```

2. Call function with image tag to start Jupyter server

```bash
cd /some/dir/
# change to any directory
jupyterHere colab 
# start with the image local/jupyter:colab at localhost:8888
```

## Access the Jupyter Server

1. Chrome in headless mode: `google-chrome --incognito --app=http://localhost:8888/lab`
2. Any browser at `http://localhost:8888/lab`
3. ~~Colab "Connect to a local runtime": `http://localhost:8888/lab` (notebooks are not saved locally)~~

