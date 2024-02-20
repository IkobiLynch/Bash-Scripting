#!/bin/bash

# Script to calculate fibonnaci sequence
set -euo pipefail

fibSequence() {
  index=$1
  if [[ "$index" -eq 1 ]]; then
    echo "0"
  elif [[ "$index" -eq 2 ]]; then
    echo "1"
  else
    echo $(( $(fibSequence $((index - 1)) ) + $(fibSequence $((index - 2))) )) 
  fi 

}

echo "Fibbonacci sequence number $1 is $(fibSequence $1)"
