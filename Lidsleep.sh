#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
#verbose=0

usage(){
    echo "Disable lid sleep on Mac without shit kexts"
    echo "Usage: $0 [-o <On|Off>]"
    echo "For detailed herrpo use -h"
    1>&2; exit 1;
}
Help(){
    # Display Help
    echo "Add description of the script functions here."
    echo
    echo "Syntax: [-h|o <On|Off]"
    echo "Options:"
    echo "h     Print this Help."
    echo "o     On -> Make sleep go away. | Off -> Sleep is back in no time."
    #echo "v     Verbose mode."
}

disableSleep(){
    sudo pmset -a sleep 0; sudo pmset -a hibernatemode 0; sudo pmset -a disablesleep 1;
}

enableSleep(){
    sudo pmset -a sleep 1; sudo pmset -a hibernatemode 3; sudo pmset -a disablesleep 0;
}

handleSleep(){
    subcommand=${OPTARG}; #Remove first arg from the list
            case "$subcommand" in
                #Parse options from getopts args for option
                On)
                    disableSleep;   #Call disableSleep function
                    ;;
                Off)
                    enableSleep;    #Call enableSleep function
                    ;;
            esac
}

sleepCheck(){
    echo "Sleep State:"
    pmset -g | grep -w 'SleepDisabled' #search for SleepDisabled State
    echo
    pmset -g custom | grep -w 'hibernatemode\|sleep\|Power' #search for hibernate,sleep
}


while getopts "h?o:c" opt; do
    case "${opt}" in
    h)
        #echo "Invalid Option: -$OPTARG" 1>&2
        Help
        exit 1;
        ;;
    #v)  verbose=1
    #   ;;
    o)  option=${OPTARG}
        if [ -n ${OPTARG} ]; then
            handleSleep;
        fi
        exit 1;
        ;;
    c)  
        sleepCheck
        exit 1;
        ;;
    *) 
        usage
        ;;
    \?)
        usage
        ;;
    esac
done