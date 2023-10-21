# Jupyter Lab on Docker

Starts a Jupyter Lab Server with Docker

## Setup Environment Variables

Simply run `make env` to create a `.env` file in local repository.  
The script gets the NAME and UID of local user, which will be the user when running the container.  

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

    usage_message() {
        echo "       " 
        echo "Usage: \"jupyterHere [OPTIONS] IMAGE-TAG\""
        echo "       " 
        echo "Run a Jupyter Lab Server in Current Working Directory using Docker image named \"local/jupyter\" " 
        echo "Working Directory is mounted at \"/app\" in the container " 
        echo "       " 
        echo "Options: " 
        echo "  -p      Set the published port number, default to \"8888\" " 
        echo "  -t      Set the token for server access, disabled by default (no token is needed) " 
        echo "       " 
        echo "Examples: " 
        echo "  \"jupyterHere latest\" "
        echo "      - start a server with local/jupyter:latest image at localhost:8888"
        echo "  \"jupyterHere -p 8890 -t xyz colab\" "
        echo "      - start a server with local/jupyter:colab image at localhost:8888 using token \"xyz\" "
        echo "       " 
        
    }

    local port="8888"
    local token=""

    local OPTIND p t
    while getopts "p::t::h" option; do
        case $option in
            p)
                port="$OPTARG" ;;
            t)
                token="$OPTARG" ;;
            h)
                usage_message
                return 1 ;;
            *) 
                echo "Not implemented at the moment"
                # TODO: docker image ls local/jupyter
                return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $# -eq 0 ]]; then
        echo "Missing Required Argument: <IMAGE-TAG>"
        echo "Alternatively, \"jupyterHere -h\" for help messages " 
        return 1
    fi
    local image_tag="${1:-latest}" ;

    if [[ $token ]] ; then
    # start jupyter server with the given token

        docker run -ti --rm \
            --volume $PWD:/app \
            --publish $port:8888 \
            local/jupyter:$image_tag \
            --ip=0.0.0.0 --port=8888 --no-browser --IdentityProvider.token=$token ; 

    else
    # start with command in Dockerfile

        docker run -it --rm \
            --volume $PWD:/app \
            --publish $port:8888 \
            local/jupyter:$image_tag ;

    fi
}
```

2. Call function with image tag to start Jupyter server

```bash
# change to any directory
cd /some/dir/

## start jupyter with local/jupyter:colab image
jupyterHere colab

## using port 8890
jupyterHere -p 8890 colab

## using token "abc"
jupyterHere -t abc -p 8890 colab
```

## Access the Jupyter Server

1. Chrome in headless mode: `google-chrome --incognito --app=http://localhost:8888/lab`
2. Any browser at `http://localhost:8888/lab`

