#!/usr/bin/env bash

#set -Eeuo pipefail
#trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF

This script checks the open prs in the repository and returns the list of the most productive contributors.

Usage: $(basename "${BASH_SOURCE[0]}") <repo_link>

Usage example:

$(basename "${BASH_SOURCE[0]}") https://github.com/curl/curl
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

check_environment() {
  if [[ -z "$(which curl)" ]]; then
    die "${RED}Please install curl package${NOFORMAT}"
  fi

  if [[ -z "$(which jq)" ]]; then
    die "${RED}Please install jq package${NOFORMAT}"
  fi
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "${RED}Unknown option: $1 ${NOFORMAT}" ;;
    *) break ;;
    esac
    shift
  done

  [[ $# -ne 1 ]] && die "Missing required argument: github repository url. Execute ${YELLOW}$(basename "${BASH_SOURCE[0]}") --help${NOFORMAT} for help"

  re='(github.com/)(.+)/(.+)'
  if [[ $1 =~ $re ]]; then
    USER="${BASH_REMATCH[2]}"
    REPO="${BASH_REMATCH[3]}"
  else
    die "${RED}Error in parsing github url. Execute ${YELLOW}$(basename "${BASH_SOURCE[0]}") --help${NOFORMAT} for help ${NOFORMAT}"
  fi
  return 0
}

analyze_repo() {
  DATA=$(curl https://api.github.com/repos/${USER}/${REPO}/pulls?state=open 2> /dev/null)
  [[ $? -ne 0 ]] && die "${YELLOW}Connection error${NOFORMAT}"

  PRS=$(echo "$DATA" | jq -r '.[]| [.user.login ] |@tsv')

  [[ -z "${PRS##*( )}" ]] && msg "Unable to find most productive contributors: ${YELLOW}no one open pull requests${NOFORMAT}" && return 1

  PRS=$(echo "$PRS" | sort -k1,2 | uniq -c | sort -r | awk '$1>1 {print $2,$1}')
  [[ ${#PRS} == 0 ]] && msg "Unable to find most productive contributors: ${YELLOW}authors with more than 1 open pull requests not found${NOFORMAT}" && return 1

  return 0
}

most_contributors_table() {
  [[ $1 > 0 ]] && return 1

  msg "${GREEN}Most active contributors${NOFORMAT} for ${CYAN}${USER}/${REPO}${NOFORMAT}:"
  echo "$(echo "$PRS" | awk 'BEGIN { print "Author", "Open_PRs"} { print $1, $2 }' | column -t)"
  echo
  # BEST_AUTHOR=$(echo "$PRS" | awk '{ print $1 }')
  return 0
}

all_contributors_table() {
  DATA=$(curl https://api.github.com/repos/${USER}/${REPO}/pulls?state=all 2> /dev/null)
  PRS=$(echo "$DATA" | jq -r '.[]| [.user.login ] |@tsv')
  PRS=$(echo "$PRS" | sort -k1,2 | uniq -c | sort -r)
  msg "${GREEN}PRs authors${NOFORMAT} for ${CYAN}${USER}/${REPO}${NOFORMAT}:"
  echo "$(echo "$PRS" | awk 'BEGIN { print "Author", "PRs"} { print $2, $1 }' | column -t)"
  echo

  LABELS=$(echo "$DATA" | jq -r '.[]| [ .user.login, .head.label ] |@tsv' | sort -k1,2)
  msg "${GREEN}Head labels of each pull request ${NOFORMAT} for ${CYAN}${USER}/${REPO}${NOFORMAT} by author:"
  echo "$(echo "$LABELS" | awk 'BEGIN { print "Author", "Label"} { print $1, $2 }' | column -t)"
  echo
}

setup_colors
check_environment
parse_params "$@"
analyze_repo
is_best_contributor=$?
most_contributors_table ${is_best_contributor}
all_contributors_table
