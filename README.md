<div class="Image" align="center">
  <img src="https://avatars.githubusercontent.com/u/18133?s=280&v=4" alt="Logo" width="130" height="120">
</div>
<h1 align="center">PUSHY</h1>

## About: 
Pushy is a simplified version control system inspired by Git, implemented as part of the COMP(2041|9044) 24T1 course at UNSW. This project aims to provide a concrete understanding of Git's core semantics and practice in Shell programming. Pushy consists of 10 shell scripts that mimic essential Git commands such as init, add, commit, log, show, rm, status, branch, checkout, and merge.

## Features: 
* **pushy-init:** Initializes an empty Pushy repository by creating a .pushy directory.
* **pushy-add:** Adds the contents of specified files to the repository index.
* **pushy-commit:** Commits the indexed files to the repository with a message. Commits are sequentially numbered.
* **pushy-log:** Displays a log of all commits made to the repository.
* **pushy-show:** Shows the content of a specified file at a given commit.
* **pushy-rm:** Removes files from the index or working directory, with options for force and cached removal.
* **pushy-status:** Displays the status of files in the working directory, index, and repository.
* **pushy-branch:** Manages branches by creating, deleting, or listing branches.
* **pushy-checkout:** Switches between branches.
* **pushy-merge:** Merges changes from a specified branch or commit into the current branch. (Not Implemented)

## Installation: 

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/pushy.git
   cd pushy

2. Ensure your system has /bin/dash installed. If not, you can install it using your package manager.  

3. Make the scripts executable:
   ```sh
   chmod -R 777 .

## Conclusion
Pushy serves as an educational tool to deepen understanding of version control concepts and shell scripting. By implementing a simplified version of Git, users gain hands-on experience with core version control operations and the intricacies of shell programming.
