#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LOGFILE=${DIR}/syncGitRepo.log

syncThis(){
  src_remote=$1
  dest_remote=$2
  echo "Syncing ${src_remote} -> ${dest_remote}"

  date +"%Y-%m-%d %H:%M:%S" >> ${LOGFILE}
  echo "Syncing ${src_remote} -> ${dest_remote}" >> ${LOGFILE}

  wpath=$(mktemp -d)
  pushd $wpath > /dev/null 2>&1

  git clone --mirror ${src_remote} >> ${LOGFILE} 2>&1
  cd * > /dev/null 2>&1
  git push -f --mirror ${dest_remote} >> ${LOGFILE} 2>&1

  popd > /dev/null 2>&1
  rm -rf ${wpath} > /dev/null
  echo
  echo "---" >> ${LOGFILE}
}

# Main
while read line; do
  case "$line" in \#*) continue ;; esac
  IFS=' ' read -ra splitLine <<< "$line"
  repoSource=${splitLine[0]}
  repoDest=${splitLine[1]}
  syncThis $repoSource $repoDest
done < ${DIR}/repoList.txt
