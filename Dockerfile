ARG SERVER_TYPE=basic
# SERVER_TYPE is one of [basic, pyspark, tensorflow]

############# 1. base stage, config user and jupyter lab ##############
ARG BASE_IMAGE=python:3.10-slim-buster
FROM ${BASE_IMAGE} AS base

ARG USER_NAME USER_UID
WORKDIR /app

COPY --from=node:14.20.0-buster-slim /usr/local/bin/node /usr/bin/node

RUN useradd --create-home --uid ${USER_UID} ${USER_NAME} \
    && chown -R ${USER_NAME}:${USER_NAME} /app

USER ${USER_NAME}

ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir --upgrade \
    "jupyterlab>=3.6.3,<4.0.0" "jupyterlab-vim>=0.16.0,<1.0.0"

ARG REQUIREMENTS_TXT
RUN echo "Build with Pip Requrirements from: \"${REQUIREMENTS_TXT}\""
COPY $REQUIREMENTS_TXT requirements.txt

################ 2. type stage, preprare dependencies #################
## basic branch ##
FROM base AS branch-basic

RUN pip install --user --no-cache-dir --requirement "requirements.txt"

## pyspark branch ##
FROM base AS branch-pyspark

USER root

RUN apt-get update \
    && apt-get install -y openjdk-11-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

USER ${USER_NAME}

RUN pip install --user --no-cache-dir --requirement "requirements.txt" "pyspark==3.3.0"

## tensorflow branch ##
FROM base AS branch-tensorflow

RUN pip install --user --no-cache-dir --requirement "requirements.txt"


############ 3. finalization stage, style configurations ##############
FROM branch-${SERVER_TYPE} AS final

# user prompt
RUN echo "PS1='\[\e[0;37m\][\w]\\\n\[\e[1;35m\]\u\[\e[1;34m\]@🐳\[\e[1;36m\]\h\[\e[1;34m\] ❯ \[\e[0m\]'" \
    >> /home/${USER_NAME}/.bashrc

ENTRYPOINT ["jupyter", "lab"]
# CMD ["--ip=0.0.0.0", "--port=8888", "--no-browser"]
CMD ["--ip=0.0.0.0", "--port=8888", "--no-browser", "--IdentityProvider.token=''"]
