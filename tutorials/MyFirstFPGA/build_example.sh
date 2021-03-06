#!/bin/bash

#
# Copyright (c) 2017 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#

#-------------------------------------------------------------------------------
# Change into the directory of this script
#-------------------------------------------------------------------------------
cd $(dirname "${0:?}")

#-------------------------------------------------------------------------------
# Verify tool requirements
#-------------------------------------------------------------------------------
type -P \
	quartus_sh \
> /dev/null || {
	echo ""
	echo "ERROR: could not locate all required tools in environment"
	echo ""
	exit 1
}

#-------------------------------------------------------------------------------
# Display the tools environment
#-------------------------------------------------------------------------------
cat << EOF

This example was tested with this version of the Quartus Prime software:

Quartus Prime Shell
Version 17.0.0 Build 595 04/25/2017 SJ Standard Edition
Copyright (C) 2017  Intel Corporation. All rights reserved.

If your tools are not from this version you may experience build issues related
to those version differences.

Your tool version appears to be:

EOF

quartus_sh --version || { echo "ERROR" ; exit 1 ; }

echo


#-------------------------------------------------------------------------------
# Create 'blink' project directory relative to this script
#-------------------------------------------------------------------------------
[ -d "blink" ] && {
	echo ""
	echo "ERROR: directory 'blink' already exists"
	echo ""
	exit 1
}

mkdir blink || { echo "ERROR" ; exit 1 ; }
cd blink || { echo "ERROR" ; exit 1 ; }

#-------------------------------------------------------------------------------
# Copy blink.v source file into project build directory
#-------------------------------------------------------------------------------
[ -f "../hdl_src/blink.v" ] || {
	echo ""
	echo "ERROR: cannot locate source file"
	echo "'hdl_src/blink.v'"
	echo ""
	exit 1
}

cp ../hdl_src/blink.v . || { echo "ERROR" ; exit 1 ; }

#-------------------------------------------------------------------------------
# Copy blink.sdc source file into project build directory
#-------------------------------------------------------------------------------
[ -f "../hdl_src/blink.sdc" ] || {
	echo ""
	echo "ERROR: cannot locate source file"
	echo "'hdl_src/blink.sdc'"
	echo ""
	exit 1
}

cp ../hdl_src/blink.sdc . || { echo "ERROR" ; exit 1 ; }

#-------------------------------------------------------------------------------
# Create the quartus project
#-------------------------------------------------------------------------------
[ -f "../scripts/create_quartus_project.tcl" ] || {
	echo ""
	echo "ERROR: cannot locate source file"
	echo "'scripts/create_quartus_project.tcl'"
	echo ""
	exit 1
}

quartus_sh --script="../scripts/create_quartus_project.tcl" \
|| { echo "ERROR" ; exit 1 ; }

#-------------------------------------------------------------------------------
# Compile the quartus project
#-------------------------------------------------------------------------------
quartus_sh --flow compile blink || { echo "ERROR" ; exit 1 ; }

#-------------------------------------------------------------------------------
# Program the fpga
#-------------------------------------------------------------------------------
echo "To program the FPGA via JTAG, use this command:"
echo "quartus_pgm -m jtag -c 1 -o \"p;output_files/blink.sof@2\""

exit 0

