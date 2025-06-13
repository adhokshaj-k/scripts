# Subdomain Enumeration Tool

A powerful and efficient subdomain enumeration tool that combines multiple techniques to discover subdomains of a target domain.

## Features

- Certificate Transparency Logs checking
- Subfinder integration
- Assetfinder integration
- HTTP probing with status code categorization
- Custom rate limiting
- Custom User-Agent support
- Custom HTTP headers support
- Organized output structure
- Summary report generation

## Requirements

The following tools must be installed on your system:

- `subfinder` - Fast passive subdomain enumeration tool
- `httpx` - Fast and multi-purpose HTTP toolkit
- `anew` - Add new lines from stdin to a file
- `jq` - Lightweight command-line JSON processor
- `assetfinder` - Find domains and subdomains potentially related to a given domain
- `amass` - In-depth Attack Surface Mapping and Asset Discovery

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/subd.git
cd subd
```

2. Make the script executable:
```bash
chmod +x subd.sh
```

3. Install the required tools:

```bash
# Install subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Install anew
go install -v github.com/tomnomnom/anew@latest

# Install jq
sudo apt-get install jq

# Install assetfinder
go install -v github.com/tomnomnom/assetfinder@latest

# Install amass
sudo apt-get install amass
```

## Usage

```bash
./subd.sh -d <domain> [options]
```

### Required Arguments

- `-d, --domain <domain>`     Target domain

### Optional Arguments

- `-r, --rate-limit <num>`    Rate limit for requests (default: 5)
- `-u, --user-agent <ua>`     Custom User-Agent
- `-H, --header <header>`     Custom HTTP header (can be used multiple times)
- `-h, --help`                Show help message

### Examples

Basic usage:
```bash
./subd.sh -d example.com
```

With custom rate limit:
```bash
./subd.sh -d example.com -r 10
```

With custom headers:
```bash
./subd.sh -d example.com -H 'Authorization: Bearer token' -H 'X-Custom-Header: value'
```

## Output Structure

The tool creates a directory structure as follows:

```
recon/
└── domain/
    └── domain-subdout/
        ├── domain-crt.txt           # Certificate Transparency results
        ├── domain-sub.txt           # Subfinder results
        ├── domain-all-subdomains.txt # Combined unique subdomains
        ├── domain-httpx.txt         # HTTP probing results
        ├── success.txt             # Subdomains with 200 status code
        ├── forbidden.txt           # Subdomains with 403 status code
        ├── redirect.txt            # Subdomains with 302 status code
        └── summary.txt             # Summary report
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This tool is for educational and authorized security testing purposes only. Always ensure you have proper authorization before testing any domain.
