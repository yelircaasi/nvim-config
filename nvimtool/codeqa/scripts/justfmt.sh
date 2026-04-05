if [ -z $1 ]; then _justfile="Justfile"; else _justfile=$1; fi
echo "Formatting $PWD/$_justfile"
just --fmt --unstable
