#!/bin/sh

# uninstall.sh
# unistall Lisanet PDFwriter
#
# Created by Simone Karin Lehmann on 30.08.10.
# Copyright 2010 Simone Karin Lehmann. All rights reserved.

sudo rm -f /usr/libexec/cups/backend/pdfwriter
sudo rm -f /Library/Printers/PPDs/Contents/Resources/PDFwriter.ppd
sudo rm -Rf /Library/Printers/Lisanet

# forget package
sudo pkgutil --forget de.lisanet.PDFwriter.pkg 

# restart cupsd
launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist
launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist
