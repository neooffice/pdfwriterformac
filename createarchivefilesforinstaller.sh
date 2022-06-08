#!/bin/bash

# This script is called from Xcode and creates the installer's Bom and Payload
# files. This script must be run as root as we need all of the files and
# directories within the Bom and Payload files to be chown'd to root.

set -e

function printhelpandexit {
	if [ ! -z "$1" ] ; then
		message="Error: $1"
		echo "$message" >&2
	fi
	echo "Usage: '$0' <SOURCE_ROOT> <TARGET_BUILD_DIR> <EXECUTABLE_PATH> <UNLOCALIZED_RESOURCES_FOLDER_PATH> <CODESIGNING_FOLDER_PATH> <EXPANDED_CODE_SIGN_IDENTITY_NAME>" >&2
	exit 1
}

# Parse arguments
if [ $# -lt 8 ] ; then
	printhelpandexit
fi

if [ -z "$1" -o ! -d "$1" ] ; then
	printhelpandexit "The SOURCE_ROOT argument '$1' is not set or is set to a non-existant directory"
fi
export SOURCE_ROOT="$1"
shift

if [ -z "$1" -o ! -d "$1" ] ; then
	printhelpandexit "The TARGET_BUILD_DIR argument '$1' is not set or is set to a non-existant directory"
fi
export TARGET_BUILD_DIR="$1"
shift

if [ -z "$TARGET_BUILD_DIR/$1" -o ! -f "$TARGET_BUILD_DIR/$1" ] ; then
	printhelpandexit "The EXECUTABLE_PATH argument '$1' is not set or is set to a non-existant file"
fi
export EXECUTABLE_PATH="$1"
shift

if [ -z "$TARGET_BUILD_DIR/$1" -o ! -d "$TARGET_BUILD_DIR/$1" ] ; then
	printhelpandexit "The UNLOCALIZED_RESOURCES_FOLDER_PATH argument '$1' is not set or is set to a non-existant directory"
fi
export UNLOCALIZED_RESOURCES_FOLDER_PATH="$1"
shift

if [ -z "$1" -o ! -d "$1" ] ; then
	printhelpandexit "The CODESIGNING_FOLDER_PATH argument '$1' is not set or is set to a non-existant directory"
fi
export CODESIGNING_FOLDER_PATH="$1"
shift

if [ -z "$1" ] ; then
	printhelpandexit "The EXPANDED_CODE_SIGN_IDENTITY_NAME argument '$1' is not set"
fi
export EXPANDED_CODE_SIGN_IDENTITY_NAME="$1"
shift

if [ -z "$1" ] ; then
	printhelpandexit "The USER argument '$1' is not set"
fi
export USER="$1"
shift

if [ -z "$1" ] ; then
	printhelpandexit "The GROUP argument '$1' is not set"
fi
export GROUP="$1"
shift

# This script must be run as root as we need all of the files and directories
# within the Archive.pax.gz to be chown'd to root
# This script
if [ `id -u` -ne 0 ] ; then
	printhelpandexit "'$0' must be run as root"
fi

exit 0
