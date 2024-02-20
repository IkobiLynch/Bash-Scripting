#!/bin/bash

# Script that prints fizz if multiple of 3 and buzz if multiple of 5

for i in {1..100}; do
  if (( i % 3 == 0 && i % 5 == 0 )); then
    echo "FizzBuzz" 
  elif (( $i % 3 == 0 )); then
    echo "Fizz"
  elif (( $i % 5 == 0 )); then
    echo "Buzz" 
  else
    echo "$i"
  fi
done
