#!/bin/dash


# ===========================================================================================
# COMP2041 ASSIGNMENT 1 : test05.sh
#
# Written by: Aryaman Sakthivel (z5455785)
# Date: 24-03-2024
#
# Test all error cases for pushy-status
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

#Add files to the index and commit changes
pushy-add a
pushy-commit -m first 1> /dev/null

#pushy-status: FIle in all states is same 
cat > "$expected_output" <<EOF
a - same as repo
EOF

pushy-status > "$actual_output" 2>&1
if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test"
    cat "$actual_output"
    exit 1
fi


#Create ordinary files
echo 2 > b
echo 3 > c
echo 4 > d
#Add files to the index and commit changes
pushy-add b c d
pushy-commit -m second 1> /dev/null
#Change the file in Directory
echo 3 >> b
echo 4 >> c
echo 5 >> d
#Update 'c' in index
pushy-add c d
#Change 'd' in current direcory
echo 6 > d


#pushy-status: File changed stats
cat > "$expected_output" <<EOF
a - same as repo
b - file changed, changes not staged for commit
c - file changed, changes staged for commit
d - file changed, different changes staged for commit
EOF

pushy-status > "$actual_output" 2>&1
if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test \n\nYour Output:"
    cat "$actual_output"
    exit 1
fi


#Create ordinary files 
echo 5 > e
echo 6 > f
echo 7 > g
#Add fils to index
pushy-add e f
#remove the file from index
pushy-rm --cached e 


#pushy-status: File back to untracked
cat > "$expected_output" <<EOF
a - same as repo
b - file changed, changes not staged for commit
c - file changed, changes staged for commit
d - file changed, different changes staged for commit
e - untracked
f - added to index
g - untracked
EOF

pushy-status > "$actual_output" 2>&1
if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test \n\nYour Output:"
    cat "$actual_output"
    exit 1
fi

#remove 'f' usinf rm  
pushy-rm --force f
#externally remove g
rm g

#pushy-status: Removed file stats
cat > "$expected_output" <<EOF
a - same as repo
b - file changed, changes not staged for commit
c - file changed, changes staged for commit
d - file changed, different changes staged for commit
e - untracked
EOF

pushy-status > "$actual_output" 2>&1
if  ! diff "$expected_output" "$actual_output"; then
    echo "${RED}Failed test \n\nYour Output:"
    cat "$actual_output"
    exit 1
fi


#Create files for testing added index changes
echo 8 > h 
echo 9 > i
pushy-add h i
puhsy-status 1> /dev/null
echo 9 >> h
rm i

#pushy-status: Changing files after adding to index
cat > "$expected_output" <<EOF
a - same as repo
b - file changed, changes not staged for commit
c - file changed, changes staged for commit
d - file changed, different changes staged for commit
e - untracked
h - added to index, file changed
i - added to index, file deleted
EOF

pushy-status > "$actual_output" 2>&1
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
