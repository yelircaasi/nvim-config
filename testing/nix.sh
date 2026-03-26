# PLUGIN_META=$(nix build .#nvimMeta --no-link --print-out-paths)
# echo $PLUGIN_META   # /nix/store/abc123-nvim-meta


nix build ./snapshots -o ~/.local/share/nvim-plugins
