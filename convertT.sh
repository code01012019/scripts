#!/bin/bash

rm -rf destinationT.xml
# Open sourceT.xml for reading
while read line; do

    # Check if line contains <Telephone>
    if [[ $line == *"<Telephone>"* ]]; then
        # Extract the telephone number from the line
        telephone_number=$(echo $line | sed -E 's/.*<Telephone>([^<]*)<\/Telephone>.*/\1/')

        # Remove non-numeric characters from the telephone number
        cleaned_telephone_number=$(echo $telephone_number | tr -cd [:digit:])

        # Keep the first 15 digits if the telephone number is longer than that
        cleaned_telephone_number=${cleaned_telephone_number:0:15}

        # Replace the original telephone number with the cleaned one in the line
        line=$(echo $line | sed -E "s/<Telephone>[^<]*<\/Telephone>/<Telephone>$cleaned_telephone_number<\/Telephone>/")
    fi

    # Write the line to destinationT.xml
    echo $line >> destinationT.xml

done < sourceT.xml

