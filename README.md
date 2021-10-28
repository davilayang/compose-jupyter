# Jupyter Lab on Docker

Start a Jupyter server on Docker

## Build the image

```bash
docker build -t local/jupyter --build-arg USER_NAME=$USER .
```

or  

```bash
make build
```

## Start & Access the Jupyter server

```bash
docker run -it --rm \
    --volume $PWD/notebooks:/app/notebooks \
    --volume $PWD/data:/app/data \
    --publish 8888:8888 \
    jupyter 
google-chrome --incognito --app=http://localhost:8888/lab
```

or using _Makefile_ rules

```bash
make start
google-chrome --new-window --app=http://localhost:8888/lab
```

## Add additional dependencies

Create a file `requirements.txt` at repository root and add PYPI packages to it line by line, see [official `pip` documentation](https://pip.pypa.io/en/stable/user_guide/#requirements-files). For example:  

```txt
ipython >=7.24.1,<8.0.0
```

## Mount with notebooks and data

By default, two local folders at repository root are mounted to the running Jupyter server: `notebooks` and `data`. Both are mounted at root directory `/app` inside the container.
