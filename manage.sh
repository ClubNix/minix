#!/usr/bin/env bash
#==========================================================================================
#
# SCRIPT NAME        :     manage.sh
#
# AUTHOR             :     Louis GAMBART
# CREATION DATE      :     2023.11.07
# RELEASE            :     1.0.0
# USAGE SYNTAX       :     .\manage.sh [-m|--mode] <mode> [-s|--server] <server_name>
#
# SCRIPT DESCRIPTION :     This script is used to manage a minecraft server using mcrcon binary
#
#==========================================================================================
#
#                 - RELEASE NOTES -
# v1.0.0  2023.11.07 - Louis GAMBART - Initial version
#
#==========================================================================================


#####################
#                   #
#  I - COLOR CODES  #
#                   #
#####################

No_Color='\033[0m'      # No Color
Red='\033[0;31m'        # Red
Yellow='\033[0;33m'     # Yellow
Green='\033[0;32m'      # Green
Blue='\033[0;34m'       # Blue


####################
#                  #
#  II - VARIABLES  #
#                  #
####################

SCRIPT_NAME="manage.sh"


#####################
#                   #
#  III - FUNCTIONS  #
#                   #
#####################

print_help () {
    # Print help message

    echo -e """
    ${Green} SYNOPSIS
        ${SCRIPT_NAME} [-m|--mode] <mode> [-s|--server] <server_name>

     DESCRIPTION
         This script is used to manage a minecraft server using mcrcon binary.

     OPTIONS
        -m, --mode         Specify the mode (stop|reload)
        -s, --server       Specify the server name
        -h, --help         Print the help message
        -v, --version      Print the script version
    ${No_Color}
    """
}


print_version () {
    # Print version message

    echo -e """
    ${Green}
    version       ${SCRIPT_NAME} 1.0.0
    author        Louis GAMBART
    license       GNU GPLv3.0
    script_id     0
    """
}


check_mode_option () {
    # Check if the mode option is valid
    # $1: mode

    if [[ ${1} != "stop" ]] && [[ ${1} != "reload" ]]; then
        echo -e "${Red}Invalid mode option${No_Color}"
        print_help
        exit 1
    fi
}


check_server_exists () {
    # Check if the server exists
    # $1: server name

    if [[ ! -d "/opt/minecraft/${1}" ]]; then
        echo -e "${Red}Server does not exist${No_Color}"
        exit 1
    fi
}


reload_server () {
    # reload a minecraft server using mcrcon binary
    # $1: server name

    # check if the server is active
    if [[ ! $(systemctl is-active "minecraft@${1}.service") ]]; then
        echo -e "${Red}Server is not active${No_Color}"
        exit 1
    fi

    MCRCON_PORT=$(grep "rcon.port" "/opt/minecraft/${1}/server.properties" | cut -d "=" -f 2)
    MCRCON_PASSWORD=$(grep "rcon.password" "/opt/minecraft/${1}/server.properties" | cut -d "=" -f 2)

    echo -e -n "${Yellow}Reloading the server...${No_Color}"
    /opt/minecraft/bin/mcrcon -P "${MCRCON_PORT}" -p "${MCRCON_PASSWORD}" -w 5 "say Server is going to reload in 5 seconds!" "reload confirm"
    echo -e "${Green} OK${No_Color}"
}


stop_server () {
    # Stop a minecraft server using mcrcon binary
    # $1: server name

    # check if the server is active
    if [[ ! $(systemctl is-active "minecraft@${1}.service") ]]; then
        echo -e "${Red}Server is not active${No_Color}"
        exit 1
    fi

    MCRCON_PORT=$(grep "rcon.port" "/opt/minecraft/${1}/server.properties" | cut -d "=" -f 2)
    MCRCON_PASSWORD=$(grep "rcon.password" "/opt/minecraft/${1}/server.properties" | cut -d "=" -f 2)

    echo -e -n "${Yellow}Stopping the server...${No_Color}"
    /opt/minecraft/bin/mcrcon -P "${MCRCON_PORT}" -p "${MCRCON_PASSWORD}" "say Server is going down in 60 seconds!"
    sleep 50
    /opt/minecraft/bin/mcrcon -P "${MCRCON_PORT}" -p "${MCRCON_PASSWORD}" "say Server is going down in 10 seconds!"
    sleep 5
    /opt/minecraft/bin/mcrcon -P "${MCRCON_PORT}" -p "${MCRCON_PASSWORD}" -w 1 "say 5" "say 4" "say 3" "say 2" "say 1" "say Bye bye!" stop
    echo -e "${Green} OK${No_Color}"
}


#########################
#                       #
#  IV - SCRIPT OPTIONS  #
#                       #
#########################

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -m|--mode)
            MODE="$2"
            shift
            ;;
        -s|--server)
            SERVER="$2"
            shift
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        -v|--version)
            print_version
            exit 0
            ;;
        *)
            echo -e "${Red}Unknown option: $key${No_Color}"
            print_help
            exit 0
            ;;
    esac
    shift
done


######################
#                    #
#  V - MAIN SCRIPT  #
#                    #
######################

echo -e "${Blue}Starting the script...${No_Color}\n"

if [[ -z ${MODE} ]]; then
    echo -e "${Red}No mode specified${No_Color}"
    exit 1
elif [[ -z ${SERVER} ]]; then
    echo -e "${Red}No server name specified${No_Color}"
    exit 1
else
    check_mode_option "${MODE}"
    check_server_exists "${SERVER}"
fi

if [[ ${MODE} == "reload" ]]; then
    reload_server "${SERVER}"
elif [[ ${MODE} == "stop" ]]; then
    stop_server "${SERVER}"
fi

echo -e "${Blue}Script finished${No_Color}"
