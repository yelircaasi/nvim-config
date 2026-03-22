#!/usr/bin/env sh

_previous=$PWD

#  =================== install plugins and external tools ======================
python3 scripts/installer.py \
    --config-dir="$HOME/repos/nvim-config/testing" \
    plugins install-fresh

# ==================== transpile .tl to .lua ===================================
cd teal

cyan \
    --gen-target 5.1 \
    --global-env-def vim \
    --global-env-def cfg \
    build --prune

stylua build/

cd $_previous

lua scripts/cleanup.lua teal/build/

echo "Built lua config."


cp -r teal/build/* $1
