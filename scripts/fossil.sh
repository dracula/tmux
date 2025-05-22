#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

IFS=' ' read -r -a hide_status <<< $(get_tmux_option "@dracula-fossil-disable-status" "false")
IFS=' ' read -r -a current_symbol <<< $(get_tmux_option "@dracula-fossil-show-current-symbol" "✓")
IFS=' ' read -r -a diff_symbol <<< $(get_tmux_option "@dracula-fossil-show-diff-symbol" "!")
IFS=' ' read -r -a no_repo_message <<< $(get_tmux_option "@dracula-fossil-no-repo-message" "")
IFS=' ' read -r -a no_untracked_files <<< $(get_tmux_option "@dracula-fossil-no-untracked-files" "false")
IFS=' ' read -r -a show_remote_status <<< $(get_tmux_option "@dracula-fossil-show-remote-status" "false")

# Get added, modified, updated and deleted files from git status
getChanges()
{
   declare -i added=0;
   declare -i modified=0;
   declare -i updated=0;
   declare -i deleted=0;

for i in $(cd $path; fossil changes --differ|cut -f1 -d' ')

    do
      case $i in 
      'EXTRA')
        added+=1 
      ;;
      'EDITED')
        modified+=1
      ;;
      'U')
        updated+=1 
      ;;
      'DELETED')
       deleted+=1
      ;;

      esac
    done

    output=""
    [ $added -gt 0 ] && output+="${added}A"
    [ $modified -gt 0 ] && output+=" ${modified}M"
    [ $updated -gt 0 ] && output+=" ${updated}U"
    [ $deleted -gt 0 ] && output+=" ${deleted}D"
  
    echo $output    
}


# getting the #{pane_current_path} from dracula.sh is no longer possible
getPaneDir()
{
 nextone="false"
 for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}");
 do
    if [ "$nextone" == "true" ]; then
       echo $i
       return
    fi 
    if [ "$i" == "1" ]; then
        nextone="true"
    fi
  done
}


# check if the current or diff symbol is empty to remove ugly padding
checkEmptySymbol()
{
    symbol=$1    
    if [ "$symbol" == "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# check to see if the current repo is not up to date with HEAD
checkForChanges()
{
    if [ "$(checkForFossilDir)" == "true" ]; then
        if [ "$(cd $path; fossil changes --differ)" != "" ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}     

# check if a git repo exists in the directory
checkForFossilDir()
{
    if [ -f ${path}/.fslckout ]; then
        echo "true"
    else
        echo "false"
    fi
}

# return branch name if there is one
getBranch()
{   
    if [ $(checkForFossilDir) == "true" ]; then
        echo $(cd $path; fossil branch current)
    else
        echo $no_repo_message
    fi
}

getRemoteInfo()
{
    base=$(cd $path; fossil branch current)
    remote=$(echo "$base" | cut -d" " -f1)
    out=""

    if [ -n "$remote" ]; then
        out="...$remote"
        ahead=$(echo "$base" | grep -E -o 'ahead[ [:digit:]]+' | cut -d" " -f2)
        behind=$(echo "$base" | grep -E -o 'behind[ [:digit:]]+' | cut -d" " -f2)

        [ -n "$ahead" ] && out+=" +$ahead"
        [ -n "$behind" ] && out+=" -$behind"
    fi

    echo "$out"
}

# return the final message for the status bar
getMessage()
{
    if [ $(checkForFossilDir) == "true" ]; then
        branch="$(getBranch)"
        output=""

        if [ $(checkForChanges) == "true" ]; then 
            
            changes="$(getChanges)" 
            
            if [ "${hide_status}" == "false" ]; then
                if [ $(checkEmptySymbol $diff_symbol) == "true" ]; then
		     output=$(echo "${changes} $branch")
                else
		     output=$(echo "$diff_symbol ${changes} $branch")
                fi
            else
                if [ $(checkEmptySymbol $diff_symbol) == "true" ]; then
		     output=$(echo "$branch")
                else
		     output=$(echo "$diff_symbol $branch")
                fi
            fi

        else
            if [ $(checkEmptySymbol $current_symbol) == "true" ]; then
	         output=$(echo "$branch")
            else
		 output=$(echo "$current_symbol $branch")
            fi
        fi

        [ "$show_remote_status" == "true" ] && output+=$(getRemoteInfo)
        echo "$output"
    else
        echo $no_repo_message
    fi
}

main()
{  
    path=$(getPaneDir)
    getMessage
}

#run main driver program
main 
