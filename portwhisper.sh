#!/bin/bash

# Check if nmap is installed
if ! command -v nmap &>/dev/null; then
    echo "nmap is not installed. Please install nmap first."
    exit 1
fi

# Check if the input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Function to display text in yellow
yellow() {
    echo -e "\033[0;33m$*\033[0m"
}

# Read each subdomain from the input file and run nmap scan
while read -r subdomain; do
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

done < "$input_file"
