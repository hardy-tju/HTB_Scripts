#!/bin/bash

# Base URL of the download endpoint (change as needed)
base_url="http://83.136.249.246:54082/download.php?contract="

# Loop over numbers 1 to 20 (the contract values)
for i in {1..20}; do
  # Step 1: Base64 encode the current number (no newline at the end)
  # Example: 1 becomes MQ==
  b64=$(echo -n "$i" | base64)

  # Step 2: URL encode the Base64 string
  # Some characters like '=' and '+' need to be safely encoded for URLs
  # We use python3's urllib.parse.quote for reliable URL encoding
  url_enc=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$b64'''))")

  # Step 3: Download the file using wget
  # We use -O to save each file as contract_1, contract_2, etc.
  echo "Downloading contract $i -> $base_url$url_enc"
  wget -O "contract_${i}" "${base_url}${url_enc}"
done

# End of script.
# What this does:
# - For each value 1 through 20:
#   * Base64 encodes it (e.g., 1 -> MQ==)
#   * URL encodes the Base64 result (e.g., MQ== -> MQ%3D%3D)
#   * Downloads the file for that contract number as contract_1, contract_2, etc.
