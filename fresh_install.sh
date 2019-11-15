#!/bin/bash

mkdir ~/workspace_mine/
mkdir ~/workspace_misc/

. ~/dotfiles/apt-key/set-to-machine.sh

# install essential tools
sudo apt install -y git zsh curl zsh tmux google-chrome-stable emacs26

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# after this, should restart to change shell to zsh

# install exa
# ref https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04
## install rust compiler
curl https://sh.rustup.rs -sSf | sh

## TODO: find a way to fetch latest binary
wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
unzip exa-linux-x86_64-0.8.0.zip && rm exa-linux-x86_64-0.8.0.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa

# install nerd font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git &&
  nerd-fonts/install.sh &&
  mv nerd-fonts ~/workspace_misc/

# install alacritty
sudo apt install alacritty
ln -sf $(realpath ~/dotfiles/alacritty.yml) /home/zealot/.config/alacritty/


# install snap packages
sudo snap install hub --classic

