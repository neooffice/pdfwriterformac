#!/bin/bash -x

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist

# install printer
lpadmin -p PDFwriter -E -v pdfwriter:/ -P /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd -o printer-is-shared=false
