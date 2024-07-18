#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test01.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 22-03-2024
#
# Test the pushy-init and pushy-add for erroneous inputs 
#  and the pushy-commit & pushy-log for errorless inputs
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

#Try to create a pushy repository when it already exists
cat > "$expected_output" <<EOF
$directory/pushy-init: error: .pushy already exists
EOF

pushy-init > "$actual_output" 2>&1

if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi


#Try to add a file that does not exist 
cat > "$expected_output" <<EOF
$directory/pushy-add: error: can not open 'nonexistent_file'
EOF

pushy-add nonexistent_file > "$actual_output" 2>&1

if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Create ordinary files 
seq 1 10 > a
seq 1 5 > b

#Add files to the index in .pushy
cat > "$expected_output" <<EOF
EOF

pushy-add a b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi


#Commit the files in index
cat >"$expected_output" <<EOF
Committed as commit 0
EOF

pushy-commit -m first_commit > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Changing the file in original directory
seq 11 15 >> a

pushy-add a

#Adding and commiting the updated file
cat >"$expected_output"<<EOF
Committed as commit 1
EOF

pushy-commit -m "second_commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi


#Show commit log
cat >"$expected_output"<<EOF
1 second_commit
0 first_commit
EOF

pushy-log > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi
#Return Test Passed if no test fails
echo "${GREEN}Test passed"
exit 0

