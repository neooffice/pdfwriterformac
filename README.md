## This PDFwriter for Mac fork is no longer being maintained.
## We recommend using <a href="https://github.com/rodyager/RWTS-PDFwriter/releases">RWTS-PDFwriter</a> which is another PDFwriter for Mac fork with more features.
<hr>

### Building PDFwriter for Mac

PDFWriter for Mac is built using Xcode 13 or higher on macOS 11 Big Sur or higher.

The build does codesigning so you will need to obtain the following types of codesigning certificates from Apple and install the certificates in the macOS Keychain Access application:

   Developer ID Application
   Developer ID Installer

If you build by selecting one of the Product > Build, Run, Profile, or Analyze menu items, Xcode will only build a single command line executable named "pdfwriter" that you can run or debug.

To build an installer, select the Product > Archive menu item in Xcode. This will create an archive that contains a .dmg file that is codesigned and notarized. If the build succeeds, you can find the archive by selecting the Window > Organizer menu item and then clicking on Archives in the Organizer dialog that appears.

Important: if the installer build fails with a "notarytool store-credentials" error, you will need to execute the following command once in a Terminal to cache your Apple developer ID's password in the macOS Keychain Access application so that Xcode's notarytool can fetch it and use it to upload the installer to Apple's notarization servers:

    xcrun notarytool store-credentials AC_PASSWORD --apple-id <e-mail> --team-id <team-id>
