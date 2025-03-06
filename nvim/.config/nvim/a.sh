#!/bin/bash
set -x
MY_VAR=$(ls /|head -n 1)
echo "Hello"
echo ${MY_VAR}
ls /nonexistent
