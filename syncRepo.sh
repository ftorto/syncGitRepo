#!/bin/bash

syncThis(){
  src_remote=$1
  dest_remote=$2
  echo "Syncing ${src_remote} -> ${dest_remote}"

  wpath=$(mktemp -d)
  pushd $wpath > /dev/null 2>&1

  git clone --mirror ${src_remote} > /dev/null 2>&1
  cd * > /dev/null 2>&1
  git push --mirror ${dest_remote}

  popd > /dev/null 2>&1
  rm -rf ${wpath} > /dev/null
  echo
}

# Main
while read line; do
  case "$line" in \#*) continue ;; esac
  IFS=' ' read -ra splitLine <<< "$line"
  repoSource=${splitLine[0]}
  repoDest=${splitLine[1]}
  syncThis $repoSource $repoDest
done < repoList.txt
