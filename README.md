# Jupyter Lab on Docker

Starts a Jupyter Lab Server with Docker

## Build the image

Images can be built with `docker build` command. Note the Python dependencies should be added to `requirements.txt` before building the image, following the format of [official `pip` documentation](https://pip.pypa.io/en/stable/user_guide/#requirements-files).

To make things simpler, the building command has been added to Makefile as the rule `build`. Currently it supports these named arguments:  

+ `TAG`, for Docker image tag, default to `latest`
+ `THEME`, for Jupyter Lab dark theme, default to `dracula`
  + Options are: `dracula` and `monokai`

```bash
# build with default values
make build
# build by setting image tag to "pandas"
make build TAG=pandas
```

## Start Jupyter Server

Containers can be started by `docker run` command or by executing the Makefile rules.  

### In this repository

Start the server right in this repository, two local directories (`notebooks` and `data`) are mounted to the running container. Data added to `data` local directory will be available at `/app/data/` in the container. 

```bash
# make directory
mkdir notebooks data

# start in attached mode with "pandas" image
make start TAG=pandas
## stop by Ctrl-C

# start in detached mode with "latest" image
make start-detach
## stop by make stop
```

### In any working directory

Start the server and mount current working directory to container at `/app`, i.e. the root directory of Jupyter Server. Using any of the following approach will do.

+ Using alias, run only `latest` tag image

```bash
# set alias
alias jupyterHere='docker run -it --rm -v $PWD:/app -p 8888:8888 local/jupyter'
## unalias jupyterHere

# run tag "latest" image
jupyterHere
```

+ Using function, run image tag by passing as argument, default to `latest`

```bash
function jupyterHere () {
    local image_tag="${1:-latest}" ;
    docker run -it --rm -v $PWD:/app -p 8888:8888 local/jupyter:$image_tag ;
}
## unset -f jupyterHere

# run tag "pandas" image
jupyterHere pandas 
```

## Access Jupyter Server

With Chrome in headless mode: 

```bash
google-chrome --incognito --app=http://localhost:8888/lab
google-chrome --new-window --app=http://localhost:8888/lab
```

With any other browser, go to http://localhost:8888/lab

## Notes

...
