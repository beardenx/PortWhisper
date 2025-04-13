#!/bin/bash

input_file="domains.txt"
output_file="scan_results.csv"
outdir="masscan_output"
lockfile=".print_lock"
seqfile=".seq_counter"
mkdir -p "$outdir"
echo 1 > "$seqfile"

rate=50000
ports="80,443,22,21,23,25,53,110,139,143,445,3306,3389,8080,8443"
max_jobs=5
job_count=0

# Print CSV + table header
echo "Domain,IP,Open Ports" > "$output_file"
printf "\n%-3s | %-30s | %-15s | %-30s\n" "No" "Domain" "IP" "Open Ports"
echo "----|--------------------------------|-----------------|-------------------------------"

get_seq_num() {
  flock -x 200
  num=$(cat "$seqfile")
  echo $((num + 1)) > "$seqfile"
  echo "$num"
}

scan_domain() {
  domain="$1"
  ip=$(dig +short "$domain" | tail -n1)

  if [[ -z "$ip" ]]; then
    exec 200>"$lockfile"
    seq=$(get_seq_num)
    printf "%-3s | %-30s | %-15s | %s\n" "$seq" "$domain" "N/A" "❌ Failed to resolve"
    echo "$domain,N/A,❌ Failed to resolve" >> "$output_file"
    return
  fi

  out="$outdir/$domain.txt"
  if [[ -f "$out" ]]; then
    open_ports=$(grep -oP '\d+/open' "$out" | cut -d/ -f1 | tr '\n' ',' | sed 's/,$//')
  else
    sudo masscan "$ip" -p$ports --rate=$rate -oG "$out" 2>/dev/null
    open_ports=$(grep -oP '\d+/open' "$out" 2>/dev/null | cut -d/ -f1 | tr '\n' ',' | sed 's/,$//')
  fi

  # Curl fallback
  if [[ -z "$open_ports" ]]; then
    open_ports=""
    http=$(curl -Is --max-time 3 "http://$domain" | head -n 1 | grep -E "HTTP/[0-9\.]+\s+[23]..")
    https=$(curl -Is --max-time 3 "https://$domain" | head -n 1 | grep -E "HTTP/[0-9\.]+\s+[23]..")
    [[ -n "$http" ]] && open_ports+="80,"
    [[ -n "$https" ]] && open_ports+="443,"
    open_ports=$(echo "$open_ports" | sed 's/,$//')
    [[ -z "$open_ports" ]] && open_ports="❌ None"
  fi

  # Lock + print
  exec 200>"$lockfile"
  seq=$(get_seq_num)
  printf "%-3s | %-30s | %-15s | %s\n" "$seq" "$domain" "$ip" "$open_ports"
  echo "$domain,$ip,$open_ports" >> "$output_file"
}

# Run main loop with job limiter
while read -r domain; do
  [[ -z "$domain" ]] && continue
  scan_domain "$domain" &
  ((job_count++))
  if [[ "$job_count" -ge "$max_jobs" ]]; then
    wait
    job_count=0
  fi
done < "$input_file"

wait
echo -e "\n[✓] Scan complete. Results saved to $output_file"