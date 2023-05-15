# Domainator
Domainator is a tool that will find new assets for any organization.

# Install

```bash

git clone https://github.com/gotr00t0day/Domainator.git

cd Domainator

pip3 install -r requirements.txt

```

# Usage

```bash

python3 domainator.py target.com

```

# Shodan

```bash

Domainator will extract ip ranges from subdomains, you can use these ip ranges to find assets in shodan.io

Dork: org:"Organization" NET:IP/Range

```

# Masscan

```bash

Using masscan to scan the ip ranges to find services and new assets..

Command: masscan -p80,443,8080,8443 IP/Range --rate=10000

```
