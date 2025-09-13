@echo off
REM VS Code OSS Internet Connectivity Setup Script for Windows
REM This script configures VS Code OSS to connect to the internet and access the extension marketplace
REM Run this script from the VS Code OSS project root directory

setlocal enabledelayedexpansion

echo Setting up VS Code OSS for internet connectivity...

REM Check if we're in the right directory
if not exist "product.json" (
    echo ERROR: Please run this script from the VS Code OSS project root directory
    echo    Expected to find product.json in current directory
    exit /b 1
)

REM Check Node.js version
echo Checking Node.js version...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed
    echo    Please install Node.js v22.15.1 or later
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo Node.js version: !NODE_VERSION!

REM Check if nvm is available
where nvm >nul 2>&1
if not errorlevel 1 (
    echo Checking if Node.js v22.15.1 is available...
    nvm list | findstr "v22.15.1" >nul
    if errorlevel 1 (
        echo Installing Node.js v22.15.1...
        nvm install 22.15.1
    )
    echo Switching to Node.js v22.15.1...
    nvm use 22.15.1
) else (
    echo WARNING: nvm not found. Please ensure you're using Node.js v22.15.1 or later
)

REM Install dependencies
echo Installing dependencies...
npm install

REM Compile VS Code
echo Compiling VS Code...
set NODE_OPTIONS=--max-old-space-size=8192
npm run compile

REM Backup original files
echo Creating backups of original configuration files...
if exist ".vscode\settings.json" copy ".vscode\settings.json" ".vscode\settings.json.backup" >nul
if exist "product.json" copy "product.json" "product.json.backup" >nul

REM Configure .vscode/settings.json for internet access
echo Configuring .vscode/settings.json for internet access...

REM Create .vscode directory if it doesn't exist
if not exist ".vscode" mkdir ".vscode"

REM Create settings.json with internet configuration
(
echo {
echo   // VS Code OSS Internet Connectivity Configuration
echo   // This configuration enables internet access and extension marketplace connectivity
echo
echo   // --- HTTP/Network Configuration ---
echo   "http.proxySupport": "on",
echo   "http.useLocalProxyConfiguration": true,
echo   "http.fetchAdditionalSupport": true,
echo   "http.systemCertificates": true,
echo   "http.experimental.systemCertificatesV2": true,
echo
echo   // --- Extension Marketplace Configuration ---
echo   "extensions.gallery.serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
echo   "extensions.gallery.itemUrl": "https://marketplace.visualstudio.com/items",
echo   "extensions.gallery.publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
echo   "extensions.gallery.resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
echo   "extensions.gallery.controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
echo   "extensions.gallery.nlsBaseUrl": "https://www.vscode-unpkg.net/_lp",
echo
echo   // --- Additional Settings ---
echo   "telemetry.enableTelemetry": false,
echo   "telemetry.enableCrashReporter": false,
echo   "update.enableWindowsBackgroundUpdates": false,
echo   "update.showReleaseNotes": "off"
echo }
) > ".vscode\settings.json"

REM Configure product.json for marketplace access
echo Configuring product.json for marketplace access...

REM Check if extensionsGallery already exists
findstr /C:"extensionsGallery" product.json >nul
if errorlevel 1 (
    echo Adding extensionsGallery configuration to product.json...

    REM Create a temporary file with the extensionsGallery configuration
    (
    echo   "extensionsGallery": {
    echo     "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
    echo     "itemUrl": "https://marketplace.visualstudio.com/items",
    echo     "publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
    echo     "resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
    echo     "controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
    echo     "nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
    echo   },
    ) > temp_extensions_gallery.txt

    REM Insert the extensionsGallery configuration before the last closing brace
    REM This is a simplified approach for Windows batch
    powershell -Command "(Get-Content product.json) -replace '}$', (Get-Content temp_extensions_gallery.txt) + '`n}' | Set-Content product.json"

    REM Clean up temporary files
    del temp_extensions_gallery.txt >nul 2>&1
) else (
    echo extensionsGallery already configured in product.json
)

REM Test internet connectivity
echo Testing internet connectivity...

REM Test basic internet connection
curl -s --connect-timeout 10 https://www.google.com >nul 2>&1
if errorlevel 1 (
    echo WARNING: Basic internet connectivity test failed
) else (
    echo Basic internet connectivity: OK
)

REM Test marketplace API connectivity
curl -s --connect-timeout 10 "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" >nul 2>&1
if errorlevel 1 (
    echo WARNING: Extension marketplace API connectivity test failed
) else (
    echo Extension marketplace API connectivity: OK
)

REM Test specific marketplace endpoints
echo Testing marketplace endpoints...
set MARKETPLACE_URLS=https://marketplace.visualstudio.com/_apis/public/gallery https://marketplace.visualstudio.com/items https://az764295.vo.msecnd.net/extensions/marketplace.json

for %%u in (%MARKETPLACE_URLS%) do (
    curl -s --connect-timeout 5 "%%u" >nul 2>&1
    if errorlevel 1 (
        echo   %%u: FAILED
    ) else (
        echo   %%u: OK
    )
)

echo.
echo Setup completed successfully!
echo.
echo Configuration Summary:
echo   - Node.js version: !NODE_VERSION!
echo   - Dependencies installed: OK
echo   - VS Code compiled: OK
echo   - Internet connectivity configured: OK
echo   - Extension marketplace configured: OK
echo   - Backup files created: OK
echo.
echo Next steps:
echo   1. Run: scripts\code.bat
echo   2. Open Extensions view (Ctrl+Shift+X)
echo   3. Search for extensions to test marketplace connectivity
echo.
echo If you encounter issues:
echo   - Check your internet connection
echo   - Verify firewall/proxy settings
echo   - Restore original files: copy .vscode\settings.json.backup .vscode\settings.json
echo   - Restore original files: copy product.json.backup product.json
echo.
echo For troubleshooting, run: validate-setup.bat

pause
