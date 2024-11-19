# scripts
A collection of custom scripts designed to enhance efficiency in bug bounty hunting and CTF competitions. These tools automate common tasks like subdomain enumeration, encoding, and hashing.

## Scripts Overview
## 1. SUBD
Description: Automates subdomain enumeration, certificate checking, and probing using tools like Sublist3r and HTTPX.

Features:

Exports results into categorized files:

`success.txt` - Subdomains with a `200` status code.

`forbidden.txt` - Subdomains with a `403` status code.

`redirects.txt` - Subdomains with a `302` status code.

Simplifies domain reconnaissance workflow.

## 2. enb64
Description: A simple encryption script for Base64 encoding.
Usage: Input is read from a file and encoded into Base64 format.

## 3. genmd5hach
Description: Generates MD5 hashes for input data.
Purpose: Useful for quick hashing tasks during competitions or security analysis.

## How to Use

1.Clone the repository:
```
git clone https://github.com/adhokshaj-k/scripts.git

```

2.Navigate to the directory:
```
cd scripts
```

3 Execute the script as per requirement

## Tools
[Sublister](https://github.com/aboul3la/Sublist3r)

[HTTPX](https://github.com/projectdiscovery/httpx)
