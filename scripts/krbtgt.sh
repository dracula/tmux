#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

principal=$1
label=$2

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

if [ -n "$principal" ]; then
  _principal=$principal
  if ! [[ "$_principal" =~ "@" ]]; then
    _principal="$_principal@"
  fi
  krb_principal_tgt_cache=$(klist -lan | awk -v krb_principal="^$_principal" '$0 ~ krb_principal {print $2}')
  if [ -n "$krb_principal_tgt_cache" ]; then
    krb_tgt_expire=$(date '+%H:%M:%S' -d "$(klist $krb_principal_tgt_cache | awk '/krbtgt/ {print $3,$4}')")
  else
    krb_tgt_expire=""
  fi
fi

main()
{
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  OUTPUT_STRING=""
  if [ -z "$principal" ]; then
    OUTPUT_STRING="no principal configured"
  fi

  if [ -z "$krb_tgt_expire" ]; then
      OUTPUT_STRING="$principal -"
  else
      OUTPUT_STRING="${principal} ${krb_tgt_expire}"
  fi

  if [ "$label" = "" ]; then
    echo "${OUTPUT_STRING}"
  else
    echo "${label} ${OUTPUT_STRING}"
  fi

  sleep $RATE
}

# run the main driver
main
