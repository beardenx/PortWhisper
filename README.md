# PortWhisper
PortWhisper is your trusted companion for scanning and revealing open ports on your target. With precision and discretion, it uncovers the secrets of network connectivity, providing clear and focused results

## Installation

To install PortWhisper, follow these steps:
1. Clone the repository:

   ```bash
   git clone https://github.com/beardenx/PortWhisper.git

2. Change Directory & Give Permission:

   ```bash
   cd PortWhisper && chmod +x portwhisper.sh   

3. Help Page :

   ```bash
   ./portwhisper.sh --help
   ./portwhisper.sh -f

4. Usage :

   ```bash
   Usage: ./portwhisper.sh [OPTIONS] [TARGETS]

   Options:
     -h, --help        Show this help page
     -f, --file FILE   Specify an input file with a list of targets [./portwhisper.sh -f taget.txt]
     -d, --direct      Directly specify targets on the command line [./portwhisper.sh -d example.com example2.com]

   Targets can be IP addresses or domain names.
   If both command-line targets and an input file are provided, both will be scanned.

5. Sample :

![GitHub Logo](https://github.com/beardenx/PortWhisper/blob/main/Image/Help%20Page.png)
![GitHub Logo](https://github.com/beardenx/PortWhisper/blob/main/Image/Run%20Page.png)
