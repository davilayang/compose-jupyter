# JupyterLab Themes

## Workaround

Instead of editing the default css files in extension's directory, another approach would be editing the themes from browser. Steps as following: 

1. On Chrome, install the [Stylus extension](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=en)
2. Open the extension and click "Manage". Under "Actions" clicks "Write new style" to add a new style
3. Copy the css file's content to the code section, and add a proper name
4. Edit the URL selection to "URLs starting with" and use value "http://127.0.0.1:8888/lab/tree". Save the changes
5. When JupyterLab is opened in Chrome, the theme will be applied. Or it can be enabled/disabled by with the extension

## Note

Previously, default dark and light themes can be modified by overwriting the CSS files under the extension's directory

```bash
# default dark theme css
~/.local/share/jupyter/lab/themes/@jupyterlab/theme-dark-extension/index.css
# default light theme css
~/.local/share/jupyter/lab/themes/@jupyterlab/theme-light-extension/index.css
```

This was done by adding these two COPY commands in Dockerfile at the last stage, i.e.

```dockerfile
# jupyter dark and light themes
ARG COLOR_THEME=dracula 
COPY ./themes/theme-dark-extension/index-${COLOR_THEME}.css \
    /home/${USER_NAME}/.local/share/jupyter/lab/themes/@jupyterlab/theme-dark-extension/index.css
COPY ./themes/theme-light-extension/index.css \
    /home/${USER_NAME}/.local/share/jupyter/lab/themes/@jupyterlab/theme-light-extension/index.css
```

However, this has failed to work since version `v3.6.0`.
