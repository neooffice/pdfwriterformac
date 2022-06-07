#!/bin/bash

# postinstall.sh
# pdfwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.

# copy PPD and make it read by all so that the Add Printer dialog will find it
rm -f /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd
cp -f /Library/Printers/Lisanet/pdfwriter.bundle/Contents/Resources/PDFwriter.ppd /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd
chown -f root:admin /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd
chmod -f 644 /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd

# make symlinks
ln -sf /Library/Printers/Lisanet/pdfwriter.bundle/Contents/MacOS/pdfwriter /usr/libexec/cups/backend/pdfwriter
ln -sf /var/spool/pdfwriter /Users/Shared/PDFwriter

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist
