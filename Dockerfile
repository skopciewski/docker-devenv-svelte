FROM skopciewski/devenv-base

USER root

RUN apk add --no-cache \
      ctags \
      npm

ARG user=dev
USER ${user}

ENV DEVDOTFILES_VIM_SVELTE_VER=1.0.0
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_vim_svelte/archive/${DEVDOTFILES_VIM_SVELTE_VER}.tar.gz | tar xz \
  && cd dotfiles_vim_svelte-${DEVDOTFILES_VIM_SVELTE_VER} \
  && make

ENV ZSH_TMUX_AUTOSTART=true \
  ZSH_TMUX_AUTOSTART_ONCE=true \
  ZSH_TMUX_AUTOCONNECT=false \
  ZSH_TMUX_AUTOQUIT=false \
  ZSH_TMUX_FIXTERM=false \
  TERM=xterm-256color

CMD ["/bin/zsh"]
