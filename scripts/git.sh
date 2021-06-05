#!/usr/bin/env bash

# if option = 0 check for changes
# if option = 1 get branch
option=$1
path=$2

# Dracula Color Pallette
white='#f8f8f2'
gray='#44475a'
dark_gray='#282a36'
light_purple='#bd93f9'
dark_purple='#6272a4'
cyan='#8be9fd'
green='#50fa7b'
orange='#ffb86c'
red='#ff5555'
pink='#ff79c6'
yellow='#f1fa8c'

changed_color=$red
up_to_date_color=$dark_gray
no_git_message=''
no_git_color=$dark_gray

checkForChanges()
{
    if [ "$(checkForGitDir)" == "true" ]; then
        if [ "$(git -C $path status -s)" != "" ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

checkForGitDir()
{
    if [ "$(git -C $path rev-parse --abbrev-ref HEAD)" != "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

assignColor()
{
    # If there is a change set the foreground color
    if [ "$(checkForGitDir)" == "true" ]; then   
        if [ "$(checkForChanges)" == "true" ]; then
            echo $changed_color
        else
            echo $up_to_date_color
        fi
    else
        echo $no_git_color
    fi
}

getBranch()
{   
    # return branch name if there is one
    if [ "$(git -C $path rev-parse --abbrev-ref HEAD)" != "" ]; then
        echo "$(git -C $path rev-parse --abbrev-ref HEAD) "
    else
        echo $no_git_message
    fi
}

main()
{  
    case $option in 
        0)
        assignColor
        ;;
        1)
        getBranch
        ;;
    esac
}

#run main driver program
main 
