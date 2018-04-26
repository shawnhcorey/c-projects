#!/bin/bash
# --------------------------------------
#     Title: New C/C++ Project
# Copyright: Copyright 2015, 2018 by Shawn H Corey. Some rights reserved.
#   Licence: GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html
#   Purpose: Creates a new C/C++ project.
# --------------------------------------

# set -x 

# must have at least one project
if [ $# -eq 0 ]
then
	echo "Usage: $0 project_name ..." 1>&2
	exit 1
fi

# year for copyright notice
year=$(date '+%Y')

# GECOS should have author. email & website optional
gecos=$(grep $(whoami) /etc/passwd | sed -e's/^\([^:]*:\)\{4\}//' -e's#:.*$##')

# user name
username=$(echo "$gecos" | sed -e's/^\([^:]*:\)\{4\}//' -e's/[,;:].*//')
if [ -z "$username" ]
then
    username=$(whoami)
fi
author="$username"

# get email if any
email=$(echo "$gecos" | grep -o '\<mailto[^, ]*')
if [ -n "$email" ]
then
    author="$author \`<$email>\`"
fi

# get website if any
website=$(echo "$gecos" | grep -o '\<http[^, ]*')
if [ -n "$website" ]
then
    author="$author \`<$website>\`"
fi

# replace HTTP % escapes
author=$(echo "$author" | perl -ple's/\&\#x([[:xdigit:]]{2});/chr(hex($1))/ige')

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
            echo 1>&2 "error: directory \"$prj\" not found"
            break
        fi
		cd "$prj"

        # create documentation for the project
        sed -e"s/%Y/$year/g" -e"s/%P/$prj/g" -e"s/%U/$username/g" -e"s#%E#$author#g" ../projectREADME.md > README.md

        # copy the licence
        if [ -f ../projectLicence.md ]
        then
            cp ../projectLicence.md LICENCE.md
        fi

        # link the master makefile
		ln -s ../projectMakefile.mk Makefile

        # create a git repo
        git init
        sed -e"s/%Y/$year/g" -e"s/%P/$prj/g" -e"s/%U/$username/g" ../projectGitignore > .gitignore

        # make the build directory
		mkdir build
        if [ ! -d build ]
        then
            echo 1>&2 "error: directory \"$prj\"/build not found"
            break
        fi

        # return to the base directory for the next $prj, if any
		cd ..
	fi
done

