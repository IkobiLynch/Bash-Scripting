#!/bin/bash

# Script to do calculation and display Username, script name and operation and numbers all space seperated numbers.

set -euo pipefail

# Variables - start
OPERATOR=$"{OPERATOR:-}"
NUMBERS=()
DEBUG=0
# Variables - stop

# Function definition - start
# Checks the operator passed to the script then does appropriate calculatiokn
funcCalc(){ 
  result=0
  case "$1" in
    "-")
      result="${NUMBERS[0]}"
      for num in "${NUMBERS[@]:1}"; do
        result=$(($result - $num))
      done
      echo "$result"
      ;;
    "+")
      for num in "${NUMBERS[@]}"; do
        result=$(($result + $num))
      done
      echo "$result"
      ;;
    "*")
      result=1
      for num in "${NUMBERS[@]}"; do 
        result=$(($result * $num))
      done
      echo "$result" 
      ;;
    "%")
      result="${NUMBERS[0]}" 
      for num in "${NUMBERS[@]:1}"; do 
        result=$((result % $num)) 
      done
      echo "$result"
      ;;
     *)
      echo "Unsupported operation: $operation"
      exit 1
      ;;
  esac
      
}

# Populates global NUMBERS array with numbers passed to script 
funcGetNumbers(){
  # echo "Numbers passed $1"
  IFS=" "
  read -ra NUMS <<< "$1"
  

  for num in "${NUMS[@]}"; do
    NUMBERS+=("$num")
  done
 
}

# Function definition - stop

# Script - start

while getopts ":o:n:d" opt; do
  case "${opt}" in 
    o)
      OPERATOR="$OPTARG" 
      ;; 
    n)
      funcGetNumbers "$OPTARG" 
      ;;

    d)
      # echo "Debug on"
      DEBUG=1
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

# Actually do calculation
funcCalc "$OPERATOR" "${NUMBERS[@]}"

#If debug glas was set, print additional info
if [[ $DEBUG -eq 1 ]]; then
  echo "User: $(whoami)"
  echo "Script: $0"
  echo "Operation: $OPERATOR"
  echo "Numbers: ${NUMBERS[@]}"
fi
