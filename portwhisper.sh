#!/bin/bash

# Color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#  Display script description banner
echo
echo -e "${GREEN}PortWhisper  : Script by beardenx${NC}"
echo -e "----------------------------------------"


# Function to display text in yellow
yellow() {
    echo -e "\033[0;33m$*\033[0m"
}

# Function to display the help page
show_help() {
    echo -e "Usage: $0 [OPTIONS] [TARGETS]"
    echo
    echo "Options:"
    echo "  -h, --help        Show this help page"
    echo "  -f, --file FILE   Specify an input file with a list of targets [./portwhisper.sh -f taget.txt]"
    echo "  -d, --direct      Directly specify targets on the command line [./portwhisper.sh -d example.com example2.com" 
    echo
    echo "Targets can be IP addresses or domain names."
    echo "If both command-line targets and an input file are provided, both will be scanned."
    exit 0
}

# Check if nmap is installed
if ! command -v nmap &>/dev/null; then
    echo "nmap is not installed. Please install nmap first."
    exit 1
fi

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -f|--file)
            if [ -n "$2" ] && [ -f "$2" ]; then
                input_file="$2"
                shift
            else
                echo "Error: Invalid input file specified."
                exit 1
            fi
            ;;
        -d|--direct)
            direct_targets=true
            ;;
        *)
            targets+=("$1")
            ;;
    esac
    shift
done

# If -d option is specified, use directly provided targets
if [ "$direct_targets" = true ]; then
    targets=("${targets[@]}")
fi

# Loop through command-line targets and the input file if provided
for target in "${targets[@]}"; do
    if [ -n "$target" ]; then
        echo -e
        echo "[ Scanning $(yellow "$target") ]"
        echo -e
        nmap_output=$(nmap -T4 -Pn "$target")

        # Check if the target host is not pingable
        if echo "$nmap_output" | grep -q "0 hosts up"; then
            echo "No ports open / host not pingable"
        else
            # Extract and display open ports and services using awk
            open_ports=$(echo "$nmap_output" | awk '/^ *[0-9]+\/tcp.*open/ {print $1 "\033[0;32m <<>> \033[0m" $3}')
            
            # If no open ports found, display standard Nmap output
            if [ -z "$open_ports" ]; then
                echo "Host is up. No open ports found."
            else
                echo "Host is up."
                echo "$open_ports"
            fi
        fi

        echo "----------------------------------------"
    fi
done

# If an input file was provided, process targets from the file
if [ -n "$input_file" ]; then
    while read -r subdomain; do
        if [ -n "$subdomain" ]; then
            echo -e
            echo "[ Scanning $(yellow "$subdomain") ]"
            echo -e
            nmap_output=$(nmap -T4 -Pn "$subdomain")

            # Check if the target host is not pingable
            if echo "$nmap_output" | grep -q "0 hosts up"; then
                echo "No ports open / host not pingable"
            else
                # Extract and display open ports and services using awk
                open_ports=$(echo "$nmap_output" | awk '/^ *[0-9]+\/tcp.*open/ {print $1 "\033[0;32m <<>> \033[0m" $3}')
                
                # If no open ports found, display standard Nmap output
                if [ -z "$open_ports" ]; then
                    echo "Host is up. No open ports found."
                else
                    echo "Host is up."
                    echo "$open_ports"
                fi
            fi

            echo "----------------------------------------"
        fi
    done < "$input_file"
fi
