#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

hide_arn_from_cluster=$1
extract_account=$2
hide_user=$3
just_current_context=$4
label=$5

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

current_context=$(kubectl config view --minify --output 'jsonpath={.current-context}'; echo)
current_user=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.user}'; echo)
current_cluster=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.cluster}'; echo)
current_namespace=$(kubectl config view --minify --output 'jsonpath={.contexts[?(@.name=="'$current_context'")].context.namespace}'; echo)

current_account_id=""
if [[ "$current_cluster" =~ ^arn:(aws|aws-[a-z\-]*-gov):eks:[a-z0-9\-]*:[0-9]*:cluster/[a-z0-9\-]*$ ]]; then
    if [ "$extract_account" = "true" ]; then
        current_account_id=$(echo "$current_cluster" | cut -d':' -f5)
    fi
    if [ "$hide_arn_from_cluster" = "true" ]; then
        current_cluster=${current_cluster##*/}
    fi
fi

if [ "$hide_user" = "true" ]; then
    current_user=""
fi

main()
{
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  OUTPUT_STRING=""

  if [ "$just_current_context" = "true" ]
  then
    echo "$current_context"
  else
    getFullMessage
  fi

  sleep $RATE
}

getFullMessage()
{
  if [ ! -z "$current_account_id" ]
  then
      OUTPUT_STRING="${current_account_id}/"
  fi

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
}

# run the main driver
main
