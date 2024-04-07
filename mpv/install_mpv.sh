mkdir -p ~/Library/Application\ Support/jellyfin-mpv-shim
ln -sf $(realpath mpv.conf) ~/Library/Application\ Support/jellyfin-mpv-shim
ln -sf $(realpath mpv-input.conf) ~/Library/Application\ Support/jellyfin-mpv-shim/input.conf

mkdir -p ~/.config/mpv/
ln -sf $(realpath mpv.conf) ~/.config/mpv/
ln -sf $(realpath mpv-input.conf) ~/.config/mpv/input.conf

