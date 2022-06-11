#!/bin/bash -x

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.
#
# Modified June 2022 by Patrick Luby.

# Restrict path and library loading to safe paths
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH
unset DYLD_LIBRARY_PATH

umask 022

# Add softlinks to replace pre-1.3 files so that other PDFwriter forks such as
# RWTS-PDFwriter can find our uninstall.sh script. Note that we cannot create
# these softlinks in the installer because these links will cause notarization
# to fail.
ln -sf Contents/MacOS/pdfwriter /Library/Printers/Lisanet/PDFwriter/pdfwriter
ln -sf Contents/Resources/PDFwriter.ppd /Library/Printers/Lisanet/PDFwriter/PDFwriter.ppd
ln -sf Contents/Resources/uninstall.sh /Library/Printers/Lisanet/PDFwriter/uninstall.sh

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

# install printer
lpadmin -p PDFwriter -E -v pdfwriter:/ -P /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd -o printer-is-shared=false
