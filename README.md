# Jupyter Lab on Docker

Start a Jupyter server on Docker

## Build the image

```bash
docker build -t jupyter --build-arg USER_NAME=$USER .
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

or 

```bash
make start
google-chrome --new-window --app=http://localhost:8888/lab
```

## Add additional dependencies

Add new PYPI packages to `requirements.txt` or `requirements_dev.txt`

+ `requirements.txt` for must-have dependencies
+ `requirements_dev.txt` for additional dependencies on the image

For example, 

```txt
ipython >=7.24.1,<8.0.0
```

