#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test04.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 23-03-2024
#
# Test all error status for pushy-commit and pushy-rm
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
echo 1 > a
echo 2 > b
echo 3 > c

#Add files to the index in .pushy
pushy-add a b c 

#Add and commit files simultaniously using -a
cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pushy-commit -a -m first > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Try to add commit again without any changes
cat > "$expected_output" <<EOF
nothing to commit
EOF

pushy-commit -a -m second > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Change the contents of 'a' in the curr directory
echo 2 >> a

#Try to delete 'a' from index and curr directory
cat > "$expected_output" <<EOF
$directory/pushy-rm: error: 'a' in the repository is different to the working file
EOF

pushy-rm a > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Force delete 'a' from index and curr directory
cat > "$expected_output" <<EOF
EOF

pushy-rm --force a > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Try to delete non_existing file from index
cat > "$expected_output" <<EOF
$directory/pushy-rm: error: 'non_existing_file' is not in the pushy repository
EOF

pushy-rm --cached non_existing_file > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Trying to give invalid arguments in rm
cat > "$expected_output" <<EOF
usage: pushy-rm [--force] [--cached] <filenames>
EOF

pushy-rm  > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Changing contents of 'b' in curr directory and adding it to index
echo 3 >> b
pushy-add b

#Trying to remove an updated file without committing first
cat > "$expected_output" <<EOF
$directory/pushy-rm: error: 'b' has staged changes in the index
EOF

pushy-rm b > "$actual_output" 2>&1
if ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    exit 1
fi

#Return Test Passed if no test fails
echo "${GREEN}Test passed"
exit 0
