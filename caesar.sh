#!/bin/bash

# A simple caesar script. 
# Usage: ./caesar.sh -s <shift> -i <input file> -o <output file>

while getopts ":s:i:o:" opt; do
  case ${opt} in
    s )
      shift_amount=$OPTARG
      ;;
    i )
      input_file=$OPTARG
      ;;
    o )
      output_file=$OPTARG
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      exit 1
      ;;
  esac
done

# Check if all parameters are provided
if [ -z "$shift_amount" ] || [ -z "$input_file" ] || [ -z "$output_file" ]; then
    echo "Usage: $0 -s <shift> -i <input file> -o <output file>"
    exit 1
fi

# Caesar cipher transformation
while IFS= read -r -n1 char; do
    if [[ $char =~ [a-zA-Z] ]]; then
        # Determine alphabet offset
        if [[ $char =~ [a-z] ]]; then
            offset=97
        elif [[ $char =~ [A-Z] ]]; then
            offset=65
        fi
        # Shift character and wrap around the alphabet
        ord=$(printf "%d" "'$char")
        shifted_char=$(echo "$(( (ord + shift_amount - offset) % 26 + offset ))" | awk '{printf "%c", $1}')
        echo -n "$shifted_char" >> "$output_file"
    else
        # Non-alphabet character, do not shift
        echo -n "$char" >> "$output_file"
    fi
done < "$input_file"


