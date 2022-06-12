PDFwriter for Mac is a native printer driver for macOS which will let you generate PDF files by simply printing. PDFwriter for Mac is useful for applications such as Adobe Acrobat Reader that do not provide a way to save PDF files that can be opened in the macOS Preview application because they do not use the native macOS print dialog. When a macOS application prints to the PDFwriter printer, a PDF file will be saved in the /Users/Shared/PDFwriter/<macOS_username> folder.

PDFwriter for Mac is heavily based on <a href="https://www.cups-pdf.de/">CUPS-PDF</a> but does not use Ghostscript to generate PDF files. Instead, it uses native macOS internal PDF processing.

The current version of PDFwriter for Mac works on macOS 10.12 Sierra and higher. For older versions of Mac OS X or macOS, you can download older versions of PDFwriter for Mac from <a href="https://sourceforge.net/projects/pdfwriterformac/">SourceForge</a>.

Special thanks go to the developers of the original PDFwriter for Mac source code. The original source code was copied from the GPL v2 source code in <a href="https://sourceforge.net/projects/pdfwriterformac/">SourceForge's PDFWriter for Mac project</a>. The current version contains only a few minor changes to the original source code. The main difference between the original source code and the current version is that the current version has been codesigned and notarized to comply with macOS Gatekeeper's security checks.

Special thanks also go to the developers of <a href="https://github.com/rodyager/RWTS-PDFwriter">GitHub's RWTS-PDFwriter project</a> for their code that automatically adds the printer in the Printers & Scanners panel in the System Preferences application.


Building PDFwriter for Mac
--------------------------

PDFWriter for Mac is built using Xcode 13 or higher on macOS 11 Big Sur or higher.

The build does codesigning so you will need to obtain the following types of codesigning certificates from Apple and install the certificates in the macOS Keychain Access application:

   Developer ID Application
   Developer ID Installer

If you build by selecting one of the Product > Build, Run, Profile, or Analyze menu items, Xcode will only build a single command line executable named "pdfwriter" that you can run or debug.

To build an installer, select the Product > Archive menu item in Xcode. This will create an archive that contains a .dmg file that is codesigned and notarized. If the build succeeds, you can find the archive by selecting the Window > Organizer menu item and then clicking on Archives in the Organizer dialog that appears.

Important: if the installer build fails with an "notarytool store-credentials" error, you will need to execute the following command once in a Terminal to cache your Apple developer ID's password in the macOS Keychain Access application so that Xcode's notarytool can fetch it and use it to upload the installer to Apple's notarization servers:

xcrun notarytool store-credentials AC_PASSWORD --apple-id <e-mail> --team-id <team-id>
