#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

IFS=' ' read -r -a hide_status <<< $(get_tmux_option "@dracula-hg-disable-status" "false")
IFS=' ' read -r -a current_symbol <<< $(get_tmux_option "@dracula-hg-show-current-symbol" "✓")
IFS=' ' read -r -a diff_symbol <<< $(get_tmux_option "@dracula-hg-show-diff-symbol" "!")
IFS=' ' read -r -a no_repo_message <<< $(get_tmux_option "@dracula-hg-no-repo-message" "")
IFS=' ' read -r -a no_untracked_files <<< $(get_tmux_option "@dracula-hg-no-untracked-files" "false")

# Get added, modified, and removed files from hg status
getChanges()
{
   declare -i added=0;
   declare -i deleted=0;
   declare -i modified=0;
   declare -i removed=0;
   declare -i untracked=0;

for i in $(hg -R $path status -admru)
    do
      case $i in
      'A')
        added+=1
      ;;
      '!')
       deleted+=1
      ;;
      'M')
        modified+=1
      ;;
      'R')
       removed+=1
      ;;
      '?')
       untracked+=1
      ;;

      esac
    done

    output=""
    [ $added -gt 0 ] && output+="${added}A"
    [ $modified -gt 0 ] && output+=" ${modified}M"
    [ $deleted -gt 0 ] && output+=" ${deleted}D"
    [ $removed -gt 0 ] && output+=" ${removed}R"
    [ $no_untracked_files == "false" -a $untracked -gt 0 ] && output+=" ${untracked}?"

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
    [ $no_untracked_files == "false" ] && no_untracked="-u" || no_untracked=""
    if [ "$(checkForHgDir)" == "true" ]; then
        if [ "$(hg -R $path status -admr $no_untracked)" != "" ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

# check if a hg repo exists in the directory
checkForHgDir()
{
    if [ "$(hg -R $path branch)" != "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# return branch name if there is one
getBranch()
{
    if [ $(checkForHgDir) == "true" ]; then
        echo $(hg -R $path branch)
    else
        echo $no_repo_message
    fi
}

# return the final message for the status bar
getMessage()
{
    if [ $(checkForHgDir) == "true" ]; then
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
