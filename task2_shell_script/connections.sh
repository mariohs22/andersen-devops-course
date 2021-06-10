#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-n 5] [-s] [-f organization] process

This script shows WHOIS information of a specified program (process or PID) current connections.

Required argument:

process         Specify process name or PID

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-n, --num_lines Set number of output lines, 5 by default
-s, --state     Choose connection state, all by default. Possible values: listen, established, time_wait, close_wait
-f, --field     WHOIS field to fetch, organization by default. Possible values: organization, domain, status

Usage example:

$(basename "${BASH_SOURCE[0]}") firefox
$(basename "${BASH_SOURCE[0]}") -n 10 -s established -f organization firefox
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
  if [[ -z "$(which netstat)" ]]; then
    die "${RED}Please install net-tools package${NOFORMAT}"
  fi

  if [[ -z "$(which whois)" ]]; then
    die "${RED}Please install whois package${NOFORMAT}"
  fi

  if [[ "$EUID" -ne 0 ]]; then
    msg "${ORANGE}Run as root to see more details${NOFORMAT}"
  fi
}

parse_params() {
  # default values of variables set
  process=''
  num_lines=5
  state=''
  field='organization'

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -n | --num_lines)
      num_lines="${2-}"
      shift
      ;;
    -s | --state)
      state=$(echo ${2-} | tr [[:lower:]] [[:upper:]])
      shift
      ;;
    -f | --field)
      field=$(echo ${2-} | tr [[:upper:]] [[:lower:]])
      shift
      ;;
    -?*) die "${RED}Unknown option: $1 ${NOFORMAT}" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "${RED}Missing required argument: process name or PID${NOFORMAT}"

  process="${1}"

  if [[ ! -z "$num_lines" && "$num_lines" =~ [^0-9]+ ]]; then
	die "${RED}The number of output lines -n should be a natural number${NOFORMAT}" 2
  fi

  return 0
}

get_ip_addresses() {
  ip_addresses="$(netstat -tunapl)"
  if [[ $ip_addresses =~ $state ]]; then
    ip_addresses=$(echo "$ip_addresses" | grep "$state" | awk '/'"$process"/' {print $5}')
    if [[ ! -z "$ip_addresses" ]]; then
      ip_addresses=$(echo "$ip_addresses" | cut -d: -f1 | sort | uniq -c | sort | tail -n"$num_lines" | grep -oP '(\d+\.){3}\d+')
      if [[ -z "$ip_addresses" ]]; then
        die "${RED}Could not parse any IP addresses${NOFORMAT}" 3
      fi
    else
      die "${RED}Connections with process ${PURPLE}${process}${NOFORMAT} not found${NOFORMAT}" 3
    fi
  else
    die "${RED}Connections with state ${PURPLE}${state}${NOFORMAT} not found${NOFORMAT}" 3
  fi
  return 0
}

whois_query() {
  if [[ -n "$field" ]]; then
    msg "${GREEN}Whois queries for field ${PURPLE}${field}:${NOFORMAT}"
  fi
  for i in $ip_addresses
  do
    whois_result="$(whois "$(echo $i)")"
    if [[ "$field" = "organization" ]]; then
      result="$(echo "$whois_result" | awk -F':' '/^Organization:|^org:|^Org:/ {print $2}' | tr -s ' ' | uniq)"
      if [[ -z "$result" ]]; then
        echo "$i - Organization not found"
      else
        echo "$i - $result"
      fi
    fi

    if [[ "$field" = "domain" ]]; then
      result="$(echo "$whois_result" | awk -F':' '/^Domain name:|^Domain Name:|^domain:/ {print $2}' | tr -s ' ' | uniq)"
      if [[ -z "$result" ]]; then
        echo "$i - Domain not found"
      else
        echo "$i - $result"
      fi
    fi

    if [[ "$field" = "status" ]]; then
      result="$(echo "$whois_result" | awk -F':' '/^state:/ {print $2}' | tr -s ' ' | uniq)"
      if [[ -z "$result" ]]; then
        echo "$i - Domain status not found"
      else
        echo "$i - $result"
      fi
    fi

  done
  return 0
}

setup_colors
check_environment
parse_params "$@"
get_ip_addresses
whois_query
