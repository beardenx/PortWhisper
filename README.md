# FastPortScan

FastPortScan is a simple and efficient Bash-based port scanner that uses `masscan` for quick detection of open ports and `curl` as a fallback for HTTP/HTTPS services.

This tool is intended for network administrators, security analysts, or anyone needing a lightweight port scanning utility that handles multiple domains in parallel and provides real-time output.

---

## Features

- Fast TCP port scanning using `masscan`
- Supports domain input (resolves IPs automatically)
- Parallel scanning with configurable job limits
- Fallback to `curl` to detect HTTP (80) and HTTPS (443) if filtered
- Sequential output with real-time display
- Results saved to CSV

---

## Requirements

- Bash
- `masscan`
- `curl`
- `dig` (usually included with `dnsutils`)

### Installation (Ubuntu/Debian)

```bash
sudo apt install masscan curl dnsutils
```

---

## Usage

1. Clone the repository:
```bash
git clone https://github.com/your-username/fastportscan.git
cd fastportscan
```

2. Add domains to `domains.txt` (one per line):
```
example.com
sub.example.org
```

3. Run the script:
```bash
chmod +x fastscan.sh
./fastscan.sh
```

4. The results will be displayed in the terminal and saved to:
```
scan_results.csv
```

---

## Output Example

```
No  | Domain                        | IP              | Open Ports
----|-------------------------------|-----------------|-------------------------------
1   | example.com                  | 93.184.216.34   | 80,443
2   | sub.example.org             | 203.0.113.10    | 443
```

---

## License

This project is licensed under the MIT License.
