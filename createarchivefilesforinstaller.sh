#!/bin/bash

# This script is called from Xcode and creates the installer's Bom and Payload
# files. This script must be run as root as we need all of the files and
# directories within the Bom and Payload files to be chown'd to root.

set -e

function print_help_and_exit {
	if [ ! -z "$1" ] ; then
		message="Error: $1"
		echo "$message" >&2
	fi
	echo "Usage: '$0' <TARGET_BUILD_DIR> <ARCHIVE_BUILD_DIR> <USER> <GROUP>" >&2
	exit 1
}

# Parse arguments
if [ $# -lt 4 ] ; then
	print_help_and_exit
fi

if [ -z "$1" -o ! -d "$1" ] ; then
	print_help_and_exit "The TARGET_BUILD_DIR argument '$1' is not set or is set to a non-existant directory"
fi
export TARGET_BUILD_DIR="$1"
shift

if [ -z "$1" -o ! -d "$1" ] ; then
	print_help_and_exit "The ARCHIVE_BUILD_DIR argument '$1' is not set or is set to a non-existant directory"
fi
export ARCHIVE_BUILD_DIR="$1"
shift

if [ -z "$1" ] ; then
	print_help_and_exit "The USER argument '$1' is not set"
fi
export USER="$1"
shift

if [ -z "$1" ] ; then
	print_help_and_exit "The GROUP argument '$1' is not set"
fi
export GROUP="$1"
shift

# This script must be run as root as we need all of the files and directories
# within the Archive.pax.gz to be chown'd to root
# This script
if [ `id -u` -ne 0 ] ; then
	print_help_and_exit "'$0' must be run as root"
fi

# Set a non-restrictive umask
umask 022

# Chown the bundle
chown -R root:admin "$ARCHIVE_BUILD_DIR"
chown root:wheel "$ARCHIVE_BUILD_DIR"
chown root:wheel "$ARCHIVE_BUILD_DIR/Library"
chown root:wheel "$ARCHIVE_BUILD_DIR/Users/Shared"
chown -R root:wheel "$ARCHIVE_BUILD_DIR/usr"

# Create Bom and Payload files
rm -f "$TARGET_BUILD_DIR/Bom" "$TARGET_BUILD_DIR/Payload"
( cd "$ARCHIVE_BUILD_DIR" && mkbom . "$TARGET_BUILD_DIR/Bom" )
( cd "$ARCHIVE_BUILD_DIR" && pax -w -z -x cpio . > "$TARGET_BUILD_DIR/Payload" )

# Chown the bundle, Bom and Payload files to Xcode user
chown -R "$USER:$GROUP" "$ARCHIVE_BUILD_DIR" "$TARGET_BUILD_DIR/Bom" "$TARGET_BUILD_DIR/Payload"

exit 0
