# Jupyter Lab on Docker

Starts a Jupyter Lab Server with Docker

## Build the image

Optional arguments: 

+ Dark theme for Jupyter Lab, set `COLOR_THEME` to "dracula" or "monokai"

Additional Python dependencies:

+ Add to `requirements.txt`, following the format of [official `pip` documentation](https://pip.pypa.io/en/stable/user_guide/#requirements-files)

```bash
docker build -t local/jupyter --build-arg USER_NAME=$USER --build-arg COLOR_THEME=dracula .
# or
make build
```

## Start Jupyter Server

### In this repository

Start the server right in this repository

```bash
# make directory
mkdir notebooks data

# start container
docker run -it --rm \
    --volume $PWD/notebooks:/app/notebooks \
    --volume $PWD/data:/app/data \
    --publish 8888:8888 \
    local/jupyter 
# or 
make start
# or in detached mode
make start-detach
```

Data should be added to `data` folder and will be accessible in server at `/app/data/...`

### In any working directory

Start the server and mount current working directory to server root

```bash
# set alias
alias jupyterHere='docker run -it --rm -v $PWD:/app -p 8888:8888 local/jupyter'

# (cd to a directory) and start the server
jupyterHere
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
