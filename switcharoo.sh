#!/bin/bash



# Initialize variables
declare -A actions # actions the script should perform
input_file=""
output_file=""
a_word=""
b_word=""

# Parse command-line options
while getopts ":vs:rli:o:" opt; do
  case ${opt} in
    v)
      actions[toggle_case]=1
      ;;
    s)
      actions[substitute]=1
      a_word="${OPTARG%% *}" # remove everything after first space
      b_word="${OPTARG##* }" # remove everything before the last space
      ;;
    r)
      actions[reverse_lines]=1
      ;;
    l)
      actions[lower_case]=1
      ;;
    u)
      actions[upper_case]=1
      ;;
    i)
      input_file="$OPTARG"
      ;;
    o)
      output_file="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Validate input and output file presence
if [[ -z "$input_file" || -z "$output_file" ]]; then
    echo "Both -i <input file> and -o <output file> options are required."
    exit 1
fi

# Process the file
temp_file=$(mktemp)

# Ensure temp_file is removed on script exit
trap 'rm -f "$temp_file"' EXIT

# Initially, copy input file to temp file to start processing
cp "$input_file" "$temp_file"

# Toggle case
if [[ ${actions[toggle_case]} ]]; then
    awk '{ for (i=1; i<=length; i++) {
        c = substr($0, i, 1);
        if (c ~ /[a-z]/) { printf toupper(c) } else { printf tolower(c) }
    }
    printf "\n";
    }' "$temp_file" > "$output_file"
    cp "$output_file" "$temp_file"
fi

# Substitute words
if [[ ${actions[substitute]} ]]; then
    sed "s/$a_word/$b_word/g" "$temp_file" > "$output_file"
    cp "$output_file" "$temp_file"
fi

# Reverse lines
if [[ ${actions[reverse_lines]} ]]; then
    tac "$temp_file" > "$output_file"
    cp "$output_file" "$temp_file"
fi

# Convert to lower case
if [[ ${actions[lower_case]} ]]; then
    tr '[:upper:]' '[:lower:]' < "$temp_file" > "$output_file"
    cp "$output_file" "$temp_file"
fi

# Convert to upper case
if [[ ${actions[upper_case]} ]]; then
    tr '[:lower:]' '[:upper:]' < "$temp_file" > "$output_file"
    cp "$output_file" "$temp_file"
fi

# Final copy if no action is performed (for consistency)
if [ ! -s "$output_file" ]; then
    cp "$temp_file" "$output_file"
fi
