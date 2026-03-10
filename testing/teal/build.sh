cyan \
    --gen-target 5.1 \
    --global-env-def vim \
    --global-env-def cfg \
    build --prune
stylua build/
echo "Built lua config."