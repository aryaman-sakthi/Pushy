#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test03.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 23-03-2024
#
# Test pushy commands including pushy-rm and pushy-commit with -a inputs 
# including erroneus inputs
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

#Create ordinary files 
seq 1 3 > a
seq 1 5 > b

#Add files to the index in .pushy
cat > "$expected_output" <<EOF
EOF

pushy-add a b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Change the content of the files
seq 4 6 >> a

#Add and commit files simultaniously using -a
cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pushy-commit -a -m first > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Check contents of commit after adding
cat>"$expected_output" <<EOF
1
2
3
4
5
6
EOF

pushy-show 0:a > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Trying to commit -a with erronous arguments
cat >"$expected_output" <<EOF
usage: pushy-commit [-a] -m commit-message
EOF

pushy-commit -a -n msg > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Remove a file from just the index using rm
cat >"$expected_output" <<EOF
EOF

pushy-rm --cached a > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Changing the contents of b in the index
seq 6 10 >> b
pushy-add b
seq 1 5 > b #restoring the change made to the file in the cur directory

#Trying to remove a file in index which is different 
cat >"$expected_output" <<EOF
$directory/pushy-rm: error: 'b' in index is different to both the working file and the repository
EOF

pushy-rm --cached b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Foribly trying to remove b in index
cat >"$expected_output" <<EOF
EOF

pushy-rm --force --cached b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Trying to see if b exists in index
cat >"$expected_output" <<EOF
$directory/pushy-show: error: 'b' not found in index
EOF

pushy-show :b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Return Test Passed if no test fails
echo "${GREEN}Test passed"
exit 0
