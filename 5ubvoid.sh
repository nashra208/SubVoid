#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
work_dir=""

# shows the tool name 
function banner {
echo "                                          ";
echo "▄▄▄▄▄▄▄             ▄▄▄                   ";
echo "██▀▀▀▀▀        █▄  █▀██  ██▀▀           █▄";
echo "██▄▄▄          ██    ██  ██       ▀▀    ██";
echo "▀▀▀▀██▄  ██ ██ ████▄ ██  ██ ▄███▄ ██ ▄████";
echo "▄   ▄██  ██ ██ ██ ██ ██▄ ██ ██ ██ ██ ██ ██";
echo "▀████▀  ▄▀██▀█▄████▀  ▀███▀▄▀███▀▄██▄█▀███";
echo "                                          ";
echo "                                          ";

echo -e "\n- By Nashra"

}



function subdomain () {
  # positional argument to grab user input
  target="$1"

  # checking if domain passed is in valid format
  if [[ ! $target =~ ^(([a-zA-Z0-9-]{1,63}\.)+[a-zA-Z]{2,})$ ]]; then
   
  printf "${RED}\nInvalid domain format!${NC}"
  exit 1

  else
    
    # go to home directory 
    cd $HOME
    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

    # making directory using domain name and timestamp 
    dir="${target}_${timestamp}"
    work_dir="$HOME/$dir"
    mkdir -p "$dir"
    cd "$dir" 

    # integration of subfinder and assetfinder - passive subdomain enumeration
    printf "${GREEN}Subfinder has started...${NC}"
    echo " "
    sleep 1
    subfinder -d "$target" -recursive -all -v -o "subfinder.txt"
    sleep 1

    printf "${GREEN}Assetfinder has started...${NC}"
    echo " "
    sleep 1
    assetfinder -subs-only "$target" | tee "assetfinder.txt"

    echo " "
    printf "${GREEN}\nIm Sorting your hacked list${NC}"
    sleep 1

    # combining the results of both tool and using sort for unique results
    sort -u subfinder.txt assetfinder.txt -o unqsubs.txt


    printf "${GREEN}\nIm looking for active subdomains${NC}"
    sleep 1

    # using httpx to see if they are alive - host itself is up and reachable → so httpx prints it.
    httpx -l unqsubs.txt -ports 80,4443,443,8080,8443,81,82,8888,9000,10000 -threads 100 -o finalsubs.txt

    sleep 1
    printf "${GREEN}Your results are saved in %s\n${NC}" "$HOME/$dir"
    sleep 1

  fi

}
# descriptive guide on how to use the tool 
function help (){
  echo -e "Subvoid is the automatic tool which integrate multiple tools for subdomain enumeration using passive.\n"
  echo -e "Usage:\n./5ubvoid.sh [flags]\n"
  echo -e "Flags:\n\nINPUT:"
  echo -e "-d, domains to find subdomains for         ./5ubvoid.sh -d <domain.com>  or ./5ubvoid.sh -domain <domain.com>"
}

# taking user arguments 
function arguments() {
    arg_count=$#

    # if no arguments are passed
    if [[ "$arg_count" -eq 0 ]]; then
        echo -e "${RED}No arguments passed${NC}\n"
        help
        exit 1
    fi
  
  # looping to execute the function according to argumnet passed
  # exit invalid argument exists
    i=1
    while [[ "$i" -le "$arg_count" ]]; do
        current="${!i}"

        if [[ "$current" == "--h" || "$current" == "--help" ]]; then
            help
            exit 0
        elif [[ "$current" == "--s" || "$current" == "--subdomain"]]; then
            next=$((i+1))
            domain="${!next}"
            if [[ -z "$domain" ]]; then
                echo -e "${RED}No domain provided${NC}"
                help
                exit 1
            fi
            subdomain "$domain"
            discord
            ((i++))  # skip the domain value
        else
            echo -e "${RED}Invalid arguments passed${NC}\n"
            help
            exit 1
        fi

        ((i++))
    done
}

# graceful handling if user interrupts the script execution
function cleanup(){
echo "                                      ";
echo "                                      ";
echo " █▄                █▄                 ";
echo " ██                ██                 ";
echo " ████▄ ██ ██ ▄█▀█▄ ████▄ ██ ██ ▄█▀█▄  ";
echo " ██ ██ ██▄██ ██▄█▀ ██ ██ ██▄██ ██▄█▀  ";
echo "▄████▀▄▄▀██▀▄▀█▄▄▄▄████▀▄▄▀██▀▄▀█▄▄▄  ";
echo "         ██                ██         ";
echo "       ▀▀▀               ▀▀▀          ";
echo ""
exit 1

}

# checking if tools exists in order for script execution
function check_up(){
  tools=( subfinder assetfinder httpx )
  for tool in "${tools[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then  #if tool doesnt exists send error to null device to show custom error on terminal
      echo -e "${RED}Error: '$tool' is not installed or not in PATH.${NC}"
      exit 1
    fi
  done
}  
# sending results to discord
function discord() {
  # durning subdomain function execution the results are saved at home directory
  # as webhook file is in the folder where the the script is located
  # the variable is used to reach back to the script diectory for discord webhook

    webhook=$(grep 'webhook=' "$SCRIPT_DIR/webhook.txt" | cut -d'"' -f2)

    # Split the main file into chunks of 10 lines
    # discord has a word limit of 2000 characters 
    # so splitting of file is needed to send file within word limit

    split -l 10 "$work_dir/finalsubs.txt" "$work_dir/flsbchunk_"
    echo "\n${GREEN}Please be patient. Sending your results to Discord...${NC}\n"
   

    counter=1
    for file in "$work_dir"/flsbchunk_*; do
        message=$(<"$file")
        message=$(echo "$message" | jq -Rs .)

        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": $message}" \
             "$webhook"

        echo "Message $counter has been sent!"
        sleep 1  # avoid rate limits
        ((counter++))
    done

    echo -e "\n${GREEN}All results sent. Check your Discord!!${NC}"
}


# checkup and cleanup function running before any function 
# Run cleanup if user presses Ctrl+C (SIGINT)

trap cleanup SIGINT
check_up

function main {
 
banner
arguments "$@"
discord


}


main "$@"


