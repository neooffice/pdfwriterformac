#!/bin/bash

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.


# make symlinks
ln -sf /Library/Printers/Lisanet/PDFwriter/Contents/MacOS/pdfwriter /usr/libexec/cups/backend/pdfwriter
ln -sf /Library/Printers/Lisanet/PDFwriter/Contents/Resources/PDFwriter.ppd /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist
