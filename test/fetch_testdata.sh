#!/usr/bin/env bash

try_download() {
  local testdata=$1
  local source=$2
  if [ -f "$testdata" ]; then
      echo "$testdata already exists"
  else
      echo "$testdata does not exist, downloading..."
      curl "$source" -o "$testdata"
  fi
}

try_download d