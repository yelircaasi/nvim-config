# PLUGIN_META=$(nix build .#nvimMeta --no-link --print-out-paths)
# echo $PLUGIN_META   # /nix/store/abc123-nvim-meta


nix build ./snapshots -o ~/.local/share/nvim-plugins
cat ~/.local/share/nvim-plugins/meta/plugin_paths.lua > snapshots/nix_plugin_paths.lua
cat ~/.local/share/nvim-plugins/meta/plugin_paths.json > snapshots/nix_plugin_paths.json