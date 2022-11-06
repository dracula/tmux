#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

label=$1

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

current_context=$(kubectl config view --minify --output 'jsonpath={.current-context}'; echo)
current_user=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.user}'; echo)
current_cluster=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.cluster}'; echo)
current_namespace=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.namespace}'; echo)

main()
{
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  OUTPUT_STRING=""
  if [ ! -z "$current_user" ]
  then
    OUTPUT_STRING="${current_user}@"
  fi

  if [ ! -z "$current_cluster" ]
  then
    OUTPUT_STRING="${OUTPUT_STRING}${current_cluster}"
  fi

  if [ ! -z "$current_namespace" ]
  then
    OUTPUT_STRING="${OUTPUT_STRING}:${current_namespace}"
  fi

  if [ "$OUTPUT_STRING" = "" ]
  then
    OUTPUT_STRING="kubeconfig not valid"
  fi

  if [ "$label" = "" ]
  then
    echo "${OUTPUT_STRING}"
  else
    echo "${label} ${OUTPUT_STRING}"
  fi

  sleep $RATE
}

# run the main driver
main
