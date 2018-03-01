#!/bin/sh
# --------------------------------------
#     Title: Symbolic Link to Copy
# Copyright: Copyright 2018 by Shawn H Corey. Some rights reserved.
#   Licence: GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html
#   Purpose: Converts a symbolic link to a copy of the file.
# --------------------------------------

# do all arguments
for link in "$@"
do

    # is it really a symlink?
    if [ -L "$link" ]
    then

        # is it a regular file?
        if [ -f "$link" ]
        then

            # get the path to the file
            file=$(readlink "$link")

            # must be removed or cp will copy file to itself
            rm "$link"

            # and make a copy
            cp "$file" "$link"

        else
            # report error
            echo 1>&2 "\"$link\" is not a regular file; skipped"
        fi
    else
        # report error
        echo 1>&2 "\"$link\" is not a symbolic link; skipped"
    fi
done
