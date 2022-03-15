FROM skopciewski/devenv-base:latest

USER root

RUN apk add --no-cache \
      npm

ARG user=dev
USER ${user}

# configure npm
ENV HOST_NODE_MODULES /home/${user}/.npm/modules
RUN mkdir -p "${HOST_NODE_MODULES}" \
  && npm config set prefix ${HOST_NODE_MODULES} \
  && echo "export PATH=${HOST_NODE_MODULES}/bin:\$PATH" > /home/${user}/.zshrc_local_conf/npm_env.zshrc
  # && npm install --global eslint-plugin-json

# template configs
RUN mkdir -p /home/${user}/templates
COPY --chown=${user}:${user} data/eslintrc.cjs /home/${user}/templates/
COPY --chown=${user}:${user} data/package.json /home/${user}/templates/
COPY --chown=${user}:${user} data/prettierrc /home/${user}/templates/

# configure vim
COPY --chown=${user}:${user} data/vim_plugins.txt /home/${user}/
COPY --chown=${user}:${user} data/plugin/ /home/${user}/.vim/plugin/
COPY --chown=${user}:${user} data/ftplugin/ /home/${user}/.vim/ftplugin/
COPY --chown=${user}:${user} data/coc-settings.json /home/${user}/.vim/
RUN rm -f /home/${user}/.vim/plugin/base/ale.vim
RUN mkdir -p /home/${user}/.vim/pack/svelte/start \
  && for plugin in $(cat /home/${user}/vim_plugins.txt); do \
    echo "*** Installing: $plugin ***"; \
    $(cd /home/${user}/.vim/pack/svelte/start/ && git clone --depth 1 $plugin 2>/dev/null); \
  done \
  && echo "*** Installing: coc ***" \
  && $(cd /home/${user}/.vim/pack/svelte/start/ && git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1 2>/dev/null) \
  && mkdir -p /home/${user}/.config/coc \
  && vim -c 'CocInstall -sync coc-svelte|qall'

CMD ["/bin/zsh"]
