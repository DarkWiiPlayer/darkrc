#!/bin/sh

trash() {
  mkdir -p $HOME/.trash
  if [ -z "$@" ]; then
    find $HOME/.trash -type f -exec basename {} ';'
  else
    for file in "$@"; do
      mkdir -p $HOME/.trash/$(dirname $(realpath $file))
      mv "$file" $HOME/.trash/$(realpath $file)
    done
  fi
}
