#!/bin/bash

# Default values
RATE_LIMIT=5
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
CUSTOM_HEADERS=""

# Function to display help message
show_help() {
    echo "Usage: $0 -d <domain> [options]"
    echo ""
    echo "Required:"
    echo "  -d, --domain <domain>     Target domain"
    echo ""
    echo "Options:"
    echo "  -r, --rate-limit <num>    Rate limit for requests (default: 5)"
    echo "  -u, --user-agent <ua>     Custom User-Agent"
    echo "  -H, --header <header>     Custom HTTP header (can be used multiple times)"
    echo "                            Example: -H 'Authorization: Bearer token'"
    echo "                            Example: -H 'X-Custom-Header: value'"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -d example.com"
    echo "  $0 -d example.com -r 10 -H 'Authorization: Bearer token'"
    echo "  $0 -d example.com -H 'X-API-Key: 123' -H 'X-Custom: value'"
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--domain)
            domain="$2"
            shift 2
            ;;
        -r|--rate-limit)
            RATE_LIMIT="$2"
            shift 2
            ;;
        -u|--user-agent)
            USER_AGENT="$2"
            shift 2
            ;;
        -H|--header)
            # Properly escape the header value
            header_value=$(echo "$2" | sed 's/"/\\"/g')
            CUSTOM_HEADERS="$CUSTOM_HEADERS -H \"$header_value\""
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check if domain is provided
if [ -z "$domain" ]; then
    echo "Error: Domain is required"
    show_help
fi

# Display configuration
echo "[+] Configuration:"
echo "    Domain: $domain"
echo "    Rate Limit: $RATE_LIMIT"
echo "    User-Agent: $USER_AGENT"
if [ ! -z "$CUSTOM_HEADERS" ]; then
    echo "    Custom Headers:"
    echo "$CUSTOM_HEADERS" | sed 's/-H //g' | sed 's/^/        /'
fi
echo ""

# Check if required tools are installed
check_tools() {
    local tools=("subfinder" "httpx" "anew" "jq" "assetfinder" "amass")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Error: $tool is not installed. Please install it first."
            exit 1
        fi
    done
}

check_tools

#need input
mkdir recon
cd recon
mkdir $domain
cd $domain
mkdir $domain-subdout

# Create timestamp for unique output
timestamp=$(date +"%Y%m%d_%H%M%S")

# Certificate Transparency Logs
echo "[+] Checking Certificate Transparency Logs..."
curl -s -A "$USER_AGENT" $CUSTOM_HEADERS "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > "$domain-subdout/$domain-crt.txt"

# Subfinder
echo "[+] Running Subfinder..."
subfinder -d "$domain" -rl "$RATE_LIMIT" -o "$domain-subdout/$domain-sub.txt"

# Assetfinder
echo "[+] Running Assetfinder..."
assetfinder --subs-only "$domain" | anew "$domain-subdout/$domain-sub.txt"

# Amass (passive mode)
# echo "[+] Running Amass (passive mode)..."
# amass enum -passive -d "$domain" -o "$domain-subdout/$domain-amass.txt"
# cat "$domain-subdout/$domain-amass.txt" | anew "$domain-subdout/$domain-sub.txt"

# Combine and sort unique subdomains
echo "[+] Combining and sorting results..."
sort -u "$domain-subdout/$domain-sub.txt" > "$domain-subdout/$domain-all-subdomains.txt"

# HTTP probing with more options
echo "[+] Probing HTTP services..."
cat "$domain-subdout/$domain-all-subdomains.txt" | httpx -sc -fr > $domain-subdout/$domain-httpx.txt

# Create separate files for different status codes
echo "[+] Categorizing results..."
grep "200" "$domain-subdout/$domain-httpx.txt" > "$domain-subdout/success.txt"
grep "403" "$domain-subdout/$domain-httpx.txt" > "$domain-subdout/forbidden.txt"
grep "302" "$domain-subdout/$domain-httpx.txt" > "$domain-subdout/redirect.txt"

# Create a summary report
echo "[+] Generating summary report..."
echo "Subdomain Enumeration Report for $domain" > "$domain-subdout/summary.txt"
echo "Generated on: $(date)" >> "$domain-subdout/summary.txt"
echo "Total unique subdomains found: $(wc -l < "$domain-subdout/$domain-all-subdomains.txt")" >> "$domain-subdout/summary.txt"
echo "Active subdomains (200): $(wc -l < "$domain-subdout/success.txt")" >> "$domain-subdout/summary.txt"
echo "Forbidden subdomains (403): $(wc -l < "$domain-subdout/forbidden.txt")" >> "$domain-subdout/summary.txt"
echo "Redirect subdomains (302): $(wc -l < "$domain-subdout/redirect.txt")" >> "$domain-subdout/summary.txt"

echo "[+] Done! Results saved in $domain-subdout/"



