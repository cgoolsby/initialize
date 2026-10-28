ln -s /home/gosu/Git/initialize/fedora/bashrc.fedora .bashrc
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim --headless "+Lazy! sync" +qa
