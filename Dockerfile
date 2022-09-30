ARG BASE_IMAGE=python:3.8-slim-buster
ARG SERVER_TYPE=basic
# SERVER_TYPE is one of [basic, pyspark, tensorflow]


# 1. base stage, config user and jupyter lab #
FROM ${BASE_IMAGE} AS base

ARG USER_NAME USER_UID
WORKDIR /app

COPY --from=node:14.20.0-buster-slim /usr/local/bin/node /usr/bin/node

RUN useradd --create-home --uid ${USER_UID} ${USER_NAME} \
    && chown -R ${USER_NAME}:${USER_NAME} /app

USER ${USER_NAME}

ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir --upgrade \
    "jupyterlab>=3.4.7,<4.0.0" "jupyterlab-vim>=0.15.1,<1.0.0" "jupyter_http_over_ws" \
    && jupyter serverextension enable --py jupyter_http_over_ws


# 2. type stage, preprare dependencies #
## basic branch ##
FROM base AS branch-basic

COPY requirements.txt requirements.txt 
RUN pip install --user --no-cache-dir --requirement "requirements.txt"

## pyspark branch ##
FROM base AS branch-pyspark

USER root

# TODO: try copy jdk from image
RUN apt-get update \
    && apt-get install -y openjdk-11-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

USER ${USER_NAME}

COPY requirements.txt requirements.txt 
RUN pip install --user --no-cache-dir --requirement "requirements.txt" "pyspark==3.3.0"

## tensorflow branch ##
FROM base AS branch-tensorflow

# TODO: do something for tensorflow
COPY requirements.txt requirements.txt 
RUN pip install --user --no-cache-dir --requirement "requirements.txt"


# 3. finalization stage, style configurations #
FROM branch-${SERVER_TYPE} AS final

# "dracula" or "monokai"
ARG COLOR_THEME=dracula 

# jupyter dark and light themes
COPY ./themes /home/${USER_NAME}/.local/share/jupyter/lab/themes/@jupyterlab/

# user prompt
RUN echo "PS1='\[\e[0;37m\][\w]\\\n\[\e[1;35m\]\u\[\e[1;34m\]@🐳\[\e[1;36m\]\h\[\e[1;34m\] ❯ \[\e[0m\]'" \
    >> /home/${USER_NAME}/.bashrc

ENTRYPOINT ["jupyter", "lab"]
CMD ["--ip=0.0.0.0", "--port=8888", "--no-browser", \
    "--ServerApp.token=", "--ServerApp.port_retries=0", \
    "--ServerApp.allow_origin=https://colab.research.google.com"]

# FIXME: why need g++, that wasnt needed before
