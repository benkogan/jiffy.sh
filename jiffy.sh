#!/bin/bash

## output usage
usage () {
  echo ""
  echo "  usage: jiffy [-keEhoOV] [arguments...]"
  echo ""
}

## output error
error () {
  {
    printf "error: %s\n" "${@}"
  } >&2
}

## wrap each argument in quotes
wrap() {
  printf '"%s" ' "${@}";
  echo "";
}

## convert arguments to quoted csv
csv () {
  local term=" "
  local end=""
  [ "${1}" == "newline" ] && term="\n" && end="\n"
  shift
  local tmp=""
  local args="${@}"

  if [ ! -z "${args}" ]; then
    args="${args//,/ }"
    args="${args//\"/}"
    args="${args//\'/}"
    args=($(wrap ${args}))
    let len=${#args[@]}
    for (( i = 0; i < len; i++ )); do
      local word=${args[$i]}
      if (( i + 1 != len )); then
        tmp+="${word},${term}"
      else
        tmp+="${word}${end}"
      fi
    done
  fi
  echo "${tmp}"
}

## delimit an array
array () {
  local term=" "
  [ "${1}" == "newline" ] && term="\n"
  shift

  echo "[${term}`csv ${@}`${term}]"
}

## delimit a number, boolean, or null entity, or a pre-wrapped object
value_entity () {
  local term=" "
  [ "${1}" == "newline" ] && term="\n"
  shift

  echo "${@},${term}"
}

## delimit an object
object () {
  local term=" "
  [ "${1}" == "newline" ] && term="\n"
  shift

  ## remove final trailing newline and comma from object interior
  local buf=${@}
  buf="${buf%?}"
  buf="${buf%?}"

  echo "{${term}${buf}${term}}"
}

## delimit a string
string () {
  local term=" "
  [ "${1}" == "newline" ] && term="\n"
  shift

  echo "\"${@}\",${term}"
}

## main
jiffy () {
  local version="0.0.1"
  local arg="$1"

  ## terminators
  local n="newline"
  local s="space"
  shift

  case "${arg}" in

    ## flags
    -V|--version)
      echo "${version}"
      return 0
      ;;

    -h|--help)
      usage
      return 0
      ;;

    -a|--array)
      echo "`array $s ${@}`"
      return 0
      ;;

    -A|--array-nl)
      echo "`array $n ${@}`"
      return 0
      ;;

    -e|--entity)
      echo "`value_entity $s ${@}`"
      return 0
      ;;

    -E|--entity-nl)
      echo "`value_entity $n ${@}`"
      return 0
      ;;

    -k|--key)
      echo "\"${@}\": "
      return 0
      ;;

    -s|--string)
      echo "`string $s ${@}`"
      return 0
      ;;

    -S|--string-nl)
      echo "`string $n ${@}`"
      return 0
      ;;

    *)
      if [ ! -z "${arg}" ]; then
        error "Unknown option: \`${arg}'"
        usage
        return 1
      fi
      ;;
  esac
  usage
  return 0
}

## export or run
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f jiffy
else
  jiffy "${@}"
  exit $?
fi

