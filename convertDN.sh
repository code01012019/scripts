#!/bin/bash

rm -rf destinationDN.xml
# Read lines from source.xml and write them to destination.xml
while IFS= read -r line; do
  # Check if the line contains a date in the format ddmmYY
  if [[ "$line" =~ \<DateNaissance\>([0-9]{2})([0-9]{2})([0-9]{2})\<\/DateNaissance\> ]]; then
    # Get the day, month, and year from the matched date
    day="${BASH_REMATCH[1]}"
    month="${BASH_REMATCH[2]}"
    year="${BASH_REMATCH[3]}"
    # Convert the date to the format dd/mm/YYYY
    #date=$(date "+%d/%m/%Y" -d "$day/$month/$year")
    datex=$(date "+%d/%m/%Y" -d "$month/$day/$year")
    # Replace the original date with the new formatted date
    line="${line//\<DateNaissance\>$day$month$year\<\/DateNaissance\>/\<DateNaissance\>$datex\<\/DateNaissance\>}"
  fi
  # Write the modified or unmodified line to destination.xml
  echo "$line" >> destinationDN.xml
done < sourceDN.xml
