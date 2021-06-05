# Jupyter Lab on Docker

Start a Jupyter server on Docker

## Access the Jupyter server 

```bash
google-chrome --new-window --app=http://localhost:8888/lab
google-chrome --incognito --app=http://localhost:8888/lab
```


## Add additional dependencies

Add new PYPI packages to `requirements.txt` or `requirements_dev.txt`

+ `requirements.txt` for must-have dependencies
+ `requirements_dev.txt` for additional dependencies on the image

For example, 

```txt
ipython >=7.24.1,<8.0.0
```

