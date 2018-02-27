# Assignment1 Manual

## Required Command:
1. Inform you if you're local repo is up to date with the remote repo and dispalys the modified and untracked files if you want

* Get the idea of --porcelain from <https://git-scm.com/docs/git-status>, which outpuuts an easy-to-parse format for scripts 

2. Put all uncommited changes in a file changes.log

3. Put each line from every file of your project with the tag #TODO into a file todo.log

4. Check all haskell files for syntax errors and puts the results into error.log (**You have to add "main=undefined" to your file or other syntax errors would't be found.**)

* Learn the syntax awk 'NR>1' which removes first line of output from <https://stackoverflow.com/questions/7318497/omitting-the-first-line-from-any-linux-command-output/7318550>
  

## Features:
* Display the current time at the start     
⋅⋅**Reference:** <http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_01_05.html>

* Use a menu to call each functions     
⋅⋅**Reference:** Get this idea from Arian Alex Aryafar's gitHub. Source code : [Here](https://github.com/aryafara/CS1XA3/blob/master/ProjectAnalyze.sh)

* Inform the user if the ".log" files store valid information

* Calculate the size of repo

* Find the file that's larger than 1 Megabyte in the current directory

