FROM python:3.8-buster

WORKDIR /app

# pass user name from --build-args 
ARG USER_NAME

# installations
RUN apt-get update && curl -fsSL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install -y \
    vim \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash --uid 1000 ${USER_NAME}

USER ${USER_NAME}

# add user bin to PATH
ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

# install required dependencies
RUN pip install --user --no-cache-dir --upgrade \
    "jupyterlab >=3.0.16,<4.0.0" \
    "jupyterlab-vim >=0.14.2,<1.0.0" \
    "jupyterlab-spellchecker >=0.6.0,<1.0.0"

# install additional dependencies
COPY requirements.txt requirements.txt 
RUN pip install --user --no-cache-dir --requirement "requirements.txt"

# define color theme for dakr mode, currenly: dracula or monokai
ARG COLOR_THEME=dracula 

# configure jupyter themes
COPY ./theme-dark-extension/index-${COLOR_THEME}.css \
    /home/${USER_NAME}/.local/share/jupyter/lab/themes/@jupyterlab/theme-dark-extension/index.css
COPY ./theme-light-extension/index.css \
    /home/${USER_NAME}/.local/share/jupyter/lab/themes/@jupyterlab/theme-light-extension/index.css

# configure bash prompt
RUN echo "PS1='\[\e[0;37m\][\w]\\\n\[\e[1;35m\]\u\[\e[1;34m\]@🐳\[\e[1;36m\]\h\[\e[1;34m\] ❯ \[\e[0m\]'" \
    >> /home/${USER_NAME}/.bashrc

# finalizations
EXPOSE 8888

ENTRYPOINT ["jupyter", "lab"]
CMD ["--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token="]

# docker build image_jupyter/. -t local-spark-jupyter
# docker run -it --rm -p 8888:8888 -v $(pwd)/notebooks:/app local-spark-jupyter
# chrome --new-window --app=http://127.0.0.1:8888/lab
