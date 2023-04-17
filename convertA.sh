#!/bin/bash

rm -rf destinationA.xml
# Open source.xml for reading and destination.xml for writing
exec 3< sourceA.xml
exec 4> destinationA.xml

# Initialize variable for holding address tag status
addr_tag=false

# Read through source.xml line by line
while read -r line <&3; do
  # Check if line contains the address opening tag
  if [[ "$line" == *"<Adresse>"* ]]; then
    addr_tag=true
  else
    addr_tag=false
  fi

  # Replace multiple spaces with single space if between <Adresse> and </Adresse>
  if $addr_tag; then
    line=$(echo "$line" | sed -E 's/[[:space:]]+/ /g')
    # Extract the address value from the line
    address=$(echo "$line" | sed -E 's/.*<Adresse>([^<]*)<\/Adresse>.*/\1/')
    # Keep only the first 200 characters of the address value
    trimmed_address=$(echo "$address" | cut -c1-200)
    # Replace the original address value with the trimmed one in the line
    line=$(echo "$line" | sed -E "s/<Adresse>[^<]*<\/Adresse>/<Adresse>$trimmed_address<\/Adresse>/")
  fi

  # Write modified line to destination.xml
  echo "$line" >&4
done

# Close files
exec 3<&-
exec 4>&-

