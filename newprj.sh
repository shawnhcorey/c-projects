#!/bin/bash
# --------------------------------------
#
#     Title: New C/C++ Project
# Copyright: Copyright 2015 by Shawn H Corey.  All rights reserved.
#    Author: Shawn H Corey
#
#      Name: New
#      File: New
#   Created: October 19, 2015
#     Epoch: 1445266899
#
#   Purpose: Creates a new C/C++ project
#
# --------------------------------------

# must have at least on project
if [ $# -eq 0 ]
then
	echo "Usage: $0 project_name ..." 1>&2
	exit 1
fi

year=$(date '+%Y')

user=$(grep $(whoami) /etc/passwd | sed -e's/^\([^:]*:\)\{4\}//' -e's/[,;:].*//')
if [ -z "$user" ]
then
    user=$(whoami)
fi

email=$(grep $(whoami) /etc/passwd | sed -e's/^[^,]*,//' -e's/,.*$//' -e's/\./ dot /g' -e's/@/ at /g' )
if [ -n "$email" ]
then
    email="$user  \`< $email >\`"
else
    email="$user"
fi

for prj in "$@"
do
    # don't overwrite existing projects
	if [ -d "$prj" ]
	then
		echo "$prj already exists; skipping" 1>&2

	else
        # make the project directory and switch to it
		mkdir "$prj"
        if [ ! -d "$prj" ]
        then
            echo 1>&2 "error: directory \"$proj\" not found"
            break
        fi
		cd "$prj"

        # create documentation for the project
        sed -e"s/%Y/$year/g" -e"s/%P/$prj/g" -e"s/%U/$user/g" -e"s/%E/$email/g" ../projectREADME.md > README.md

        # copy the licence
        if [ -f ../projectLicence.md ]
        then
            cp ../projectLicence.md LICENCE.md
        fi

        # link the master makefile
		ln -s ../projectMakefile Makefile

        # create a git repo
        git init
        sed -e"s/%Y/$year/g" -e"s/%P/$prj/g" -e"s/%U/$user/g" ../projectGitignore > .gitignore

        # make the build directory and switch to it
		mkdir build
        if [ ! -d build ]
        then
            echo 1>&2 "error: directory \"$proj\"/build not found"
            break
        fi
		cd build

        # link the build makefile
		ln -s ../../projectBuildMakefile Makefile

        # return to the base directory for the next $prj, if any
		cd ../..
	fi
done

