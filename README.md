<!--
     Title: C/C++ Projects
 Copyright: Copyright 2018 by Shawn H Corey. Some rights reserved.
   Licence: GNU GENERAL PUBLIC LICENSE v3.0, see https://www.gnu.org/licenses/gpl-3.0.html
   Purpose: A set of tools for creating and compiling small C/C++ projects.
-->

# NAME

c-projects - A set of tools for creating and compiling small C/C++ projects.

# VERSION

This document refers to c-projects version 1.00

# DESCRIPTION

C/C++ Projects is a set of tools for the creation and compiling of small
projects written in C/C++.

Developing small projects in C/C++ that have multiple sources files can be tedious.
Adding, removing, or renaming sources files require changes to the Makefile and is often repetitive.
This tool set is designed to replace maintenance of the Makefile with automatic compiling of the source files.

All one has to do is add, edit, or remove the source files and run `make`.
This tool set will determine the sources files and their dependencies
and compile them.

## Downloading

Decide where to place this tool set and clone the Github repo.
To place it in your home directory:

    cd ~
    git clone https://github.com/shawnhcorey/c-projects.git

It is now ready for new projects.

## Creating New Projects

Use `newprj.sh` to create a directory for the project.
This also sets up the necessary files to compile it.
Then change to the directory and add the C/C++ files.
To make the executable, run `make`.

    cd ~/c-projects
    newprj.sh myproject
    cd myproject

    # add C/C++ files

    make

The `make` will create an executable with the same name as the project.
In the above case, it will be named `myproject`.

You can edit the C/C++ files and use `make` to recompile.

## Updates

The tools can be updated with `update.sh`.

    update.sh

# REQUIREMENTS

This requires the packages to build and make C programs.

## Debian-based Linux

Use the following command to install the required packages.

    sudo apt install build-essential man-pages git-all

# BUGS AND LIMITATIONS

(none known)

# SEE ALSO

    bash(1), gcc(1), make(1), git(1)

# ORIGINAL AUTHOR

Shawn H Corey `<shawnhcorey at gmail dot com>`

## Contributing Authors

(Insert your name here if you modified this program or its documentation.
 Do not remove this comment.)

# ACKNOWLEDGEMENTS

(none yet)

# COPYRIGHT & LICENCES

Copyright 2018 by Shawn H Corey. Some rights reserved.

## Software Licence

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

## Document Licence

Permission is granted to copy, distribute and/or modify this document under the
terms of the GNU Free Documentation License, Version 1.3 or any later version
published by the Free Software Foundation; with the Invariant Sections being
"ORIGINAL AUTHOR", "COPYRIGHT & LICENCES", "Software Licence",
and "Document Licence".

You should have received a copy of the GNU Free Documentation Licence
along with this document; if not, see https://www.gnu.org/licenses/

