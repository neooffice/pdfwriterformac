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
	echo "Usage: '$0' <SOURCE_ROOT> <TARGET_BUILD_DIR> <EXECUTABLE_PATH> <UNLOCALIZED_RESOURCES_FOLDER_PATH> <CODESIGNING_FOLDER_PATH> <EXPANDED_CODE_SIGN_IDENTITY_NAME>" >&2
	exit 1
}

# Parse arguments
if [ $# -lt 8 ] ; then
	print_help_and_exit
fi

if [ -z "$1" -o ! -d "$1" ] ; then
	print_help_and_exit "The SOURCE_ROOT argument '$1' is not set or is set to a non-existant directory"
fi
export SOURCE_ROOT="$1"
shift

if [ -z "$1" -o ! -d "$1" ] ; then
	print_help_and_exit "The TARGET_BUILD_DIR argument '$1' is not set or is set to a non-existant directory"
fi
export TARGET_BUILD_DIR="$1"
shift

if [ -z "$TARGET_BUILD_DIR/$1" -o ! -f "$TARGET_BUILD_DIR/$1" ] ; then
	print_help_and_exit "The EXECUTABLE_PATH argument '$1' is not set or is set to a non-existant file"
fi
export EXECUTABLE_PATH="$1"
shift

if [ -z "$TARGET_BUILD_DIR/$1" -o ! -d "$TARGET_BUILD_DIR/$1" ] ; then
	print_help_and_exit "The UNLOCALIZED_RESOURCES_FOLDER_PATH argument '$1' is not set or is set to a non-existant directory"
fi
export UNLOCALIZED_RESOURCES_FOLDER_PATH="$1"
shift

if [ -z "$1" -o ! -d "$1" ] ; then
	print_help_and_exit "The CODESIGNING_FOLDER_PATH argument '$1' is not set or is set to a non-existant directory"
fi
export CODESIGNING_FOLDER_PATH="$1"
shift

if [ -z "$1" ] ; then
	print_help_and_exit "The EXPANDED_CODE_SIGN_IDENTITY_NAME argument '$1' is not set"
fi
export EXPANDED_CODE_SIGN_IDENTITY_NAME="$1"
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

# Create build directories
codesigning_bundle_dir=`dirname "$CODESIGNING_FOLDER_PATH"`
codesigning_bundle_name=`basename "$CODESIGNING_FOLDER_PATH"`
renamed_bundle_name=PDFwriter
archive_build_dir="$TARGET_BUILD_DIR/$codesigning_bundle_name.archive"
rm -Rf "$archive_build_dir"

lisanet_archive_build_dir="$archive_build_dir/Library/Printers/Lisanet"
ppd_archive_build_dir="$ppd_archive_build_dir/Library/Printers/PPDs/Contents/Resources"
shared_user_archive_build_dir="$archive_build_dir/Users/Shared"
mkdir -p "$lisanet_archive_build_dir"
mkdir -p "$ppd_archive_build_dir"
mkdir -p "$shared_user_archive_build_dir"

# Copy the bundle
( cd "$codesigning_bundle_dir" && tar cf - "$codesigning_bundle_name" ) | ( cd "$lisanet_archive_build_dir" && tar xvf - )
mv "$lisanet_archive_build_dir/$UNLOCALIZED_RESOURCES_FOLDER_PATH/PDFwriter.ppd" "$ppd_archive_build_dir/PDFwriter.ppd"
ln -s "/var/spool/pdfwriter" "$shared_user_archive_build_dir/PDFwriter"

# Set permissions required by cups
find "$archive_build_dir" -type d -exec chmod 755 {} \;
find "$archive_build_dir" -type f -exec chmod 644 {} \;
find "$archive_build_dir" -type l -exec chmod -h 644 {} \;
chmod 700 "$lisanet_archive_build_dir/$EXECUTABLE_PATH"
chmod 750 "$lisanet_archive_build_dir/$UNLOCALIZED_RESOURCES_FOLDER_PATH/uninstall.sh"

# Rename, codesign, and chown the copied bundle
new_bundle_name=PDFwriter
mv "$lisanet_archive_build_dir/$codesigning_bundle_name" "$lisanet_archive_build_dir/$renamed_bundle_name"
( cd "$lisanet_archive_build_dir" && sudo -u "$USER" codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY_NAME" "$renamed_bundle_name" )
chown -R root:admin "$lisanet_archive_build_dir"
chown root:wheel "$lisanet_archive_build_dir/Library"
chown root:wheel "$lisanet_archive_build_dir/Users/Shared"

exit 0
