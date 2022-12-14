FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get install -y \
	git \
	curl \
	neovim \
    ripgrep;

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&\
	apt-get install -y nodejs

ENV RUSTUP_HOME=/root/rustup \
    CARGO_HOME=/root/cargo \
    PATH=/root/cargo/bin:$PATH \
    RUST_SRC_PATH=/root/rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src \
    USER=root

RUN curl -f -L https://static.rust-lang.org/rustup.sh -O \
 && sh rustup.sh -y \
    --no-modify-path \
    --profile minimal \
 && rustup default stable \
 && rustup component add \
    rustfmt \
 && rm rustup.sh \
 ;


RUN curl -L -o rust-analyzer-x86_64-unknown-linux-gnu.gz https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-x86_64-unknown-linux-gnu.gz \
	&& gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz \
	&& mkdir -p ~/.local/bin \
	&& mv rust-analyzer-x86_64-unknown-linux-gnu ~/.local/bin/rust-analyzer \
	&& chmod +x ~/.local/bin/rust-analyzer

RUN curl -fLo /usr/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.2.2/shfmt_v3.2.2_linux_amd64 && chmod +x /usr/bin/shfmt

RUN curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY init.vim /root/.config/nvim/init.vim
COPY coc-settings.json /root/.config/nvim/coc-settings.json

RUN nvim +PlugInstall +UpdateRemotePlugins +qa --headless 2> /dev/null


RUN mkdir -p "root/.config/coc/extensions"
WORKDIR "root/.config/coc/extensions"
RUN if [ ! -f package.json ] ; then echo '{"dependencies": {}}' > package.json ; fi && \ 
npm install coc-rust-analyzer --global-style --ignore-scripts --nob-bin-link --no-package-lock --only=prod

WORKDIR "$HOME/p"
