#!/bin/bash

#Kexin Liu
#MAC ID: 400138024

printf "Hello, this is Kexin Liu's first Bash Script assignment for CS 1XA3.\n\n\n" #A brief description

printf "Today is `date`.\n\n\n" 

#1 Inform if your local repo is up to date with the remote repo
upToDate() {

	var = $
	if [ -z "$(git status --porcelain)" ]
	then echo "Already up to date with remote repo."
	else
		read -r -p "Out of date. Would you like to see what files have not been updated? (y/n)"  cond1
		case "$cond1" in
			[yY])
				git status --porcelain
				;;
			*)
				echo "Done."
				;;
		esac
	fi
}

#2 Puts all uncommited changes in a file changes.log
changes() {

	git diff > changes.log
	if [ -s changes.log ]
	then echo "Changes have been put into changes.log."
	else
		echo "No uncommited changes."
	fi
}

#3 Puts each line from every file of your project with the tag #TODO into a file todo.log
toDo() {

	grep -ir "#TODO" ../CS1XA3 > todo.log
	if [ -s todo.log ] 
	then echo "Lines with tag #TODO have been put into todo.log."
	else
		echo "No #TODO tags found."
	fi
}


#4 Checks all haskell files for syntax errors and puts the results into error.log
error() {

	shopt -s nullglob
	find  . -name "*.hs" -print0 | 
		while IFS='' read -r -d $'\0' file
		do
			ghc -fno-code "$file" | awk 'NR>1' &> error.log 
		done
	if [ -s error.log ] 
	then echo "Syntax errors of haskell files have been put into error.log."
	else
		echo "No haskell files found or no syntax errors found."
	fi
}


size() { #Calculate the size of repo

	du -h
} 

fLargeFile() { #Find the files that are more than 1 Megabytes in the current repository

	find . -size +1M 
}

#Display a menu
read -r -p "Here's a menu that allows you to execute some useful commands:
Type "1" -- Inform if your local repo is up to date with the remote repo
Type "2" -- Put all uncommited changes in a file changes.log 
Type "3" -- Put each line from every file of your project with the tag #TODO into a file todo.log
Type "4" -- Check all haskell files for syntax errors and puts the results into error.log
Type "5" -- Calculate the size of repo
Type "6" -- Find the files that are more than 1 Megabyte    :" commd
case "$commd" in
	[1])
		upToDate
		;;
	[2])
		changes
		;;
	[3])
		toDo
		;;
	[4])
		error
		;;
	[5])
		size
		;;
	[6])
		fLargeFile
		;;
	*)
		echo "Invalid input." 
		;;
esac	


