#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test00.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 21-03-2024
#
# Test the pushy-init and pushy-add for errorless inputs
# ===========================================================================================


# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

#Green Color for output
GREEN='\033[0;32m'
#Red Color for output
RED='\033[0;31m'

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT
 

# Create pushy repository

cat > "$expected_output" <<EOF
Initialized empty pushy repository in .pushy
EOF

pushy-init > "$actual_output" 2>&1

if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Create an ordinary file in the current directory
seq 1 5 > a

#Add the file to the index in .pushy
cat > "$expected_output" <<EOF
EOF

pushy-add a > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

echo "${GREEN}Test Passed"
exit 0


