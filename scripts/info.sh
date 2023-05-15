#!/bin/bash

# Define output file
NW_file="${1%.com}-NW.txt"
IPspace_file="ipspace.txt"
subdomain_file="subdomains.txt"
# Clear output file
> "$NW_file"
> "$IPspace_file"
> "$subdomain_file"

echo "Searching crt.sh for subdomains of ${1}"
curl -s "https://crt.sh/?q=%25.${1}&output=json" | jq -r ".[].name_value" | sed "s/*.//g" | sort -u | tee subdomains.txt

# Running asnmap to obtain IP addresses of subdomains
echo "Running asnmap to obtain IP addresses..."
asn=$(./asnmap -d "${1}" -silent)
for ip in $asn; do
  network_info=$(whois "$ip" | grep 'OrgName: \|CIDR: ' | tr -s '[[:blank:]]' | cut -d ":" -f 2 | sort -u | awk '$1=$1')

  # Print the network information for the IP address to the terminal
  echo "IP address: ${ip}"
  echo "${network_info}"
  echo ""

  # Write the network information to the output file
  echo "IP address: ${ip}" >> "$NW_file"
  echo "${network_info}" >> "$NW_file"
  echo "" >> "$NW_file"
done >> "$NW_file"

for domain in $(cat "$subdomain_file"); do
  # Look up IP addresses for the subdomain using nslookup
  ips=$(nslookup "$domain" | grep "Address: " | tr -s '[[:blank:]]' | cut -d ":" -s -f 2-11 | sort -u | sed -e 's/^[ \t]*//')

  # Iterate over the IP addresses and look up network information using whois
  for ip in $ips; do
    network_info=$(whois -I "$ip" | grep 'OrgName: \|CIDR: ' | tr -s '[[:blank:]]' | cut -d ":" -f 2 | sort -u | awk '$1=$1')

    # Print the network information for the IP address to the terminal
    echo "IP address: ${ip}"
    echo "${network_info}"
    echo ""

    # Write the network information to the output file
    echo "IP address: ${ip}" >> "$NW_file"
    echo "${network_info}" >> "$NW_file"
    echo "" >> "$NW_file"
  done
done

# Remove duplicate records from the output file
sort -u "$NW_file" -o "$NW_file"

# Display a message indicating the number of unique records in the output file
count=$(wc -l < "$NW_file")
echo "The file '$NW_file' contains $count unique records."