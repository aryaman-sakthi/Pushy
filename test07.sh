#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test07.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 25-03-2024
#
# Test branch create function
# ===========================================================================================

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

#path to the directory where pushy commands are stored
directory=$(realpath .pushy-init | sed 's/\/.pushy-init//g')

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

#Add and commit a file
touch a 
pushy-add a
pushy-commit -m comit0 1> /dev/null

#Create branches
pushy-branch b1
pushy-branch b2

ls -A .pushy/branches
cat .pushy/branches/active_branch
#Test if bracnhes were crated successfully
cat > "$expected_output" <<EOF
b1
b2
master
EOF

pushy-branch > "$actual_output" 2>&1
if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test \n\nYour Output:"
    cat "$actual_output"
    exit 1
fi


#Show output
echo "Your Output:"
cat "$actual_output"

#Return Test Passed if no test fails
echo "${GREEN} \nTest passed"
exit 0