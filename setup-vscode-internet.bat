@echo off
REM VS Code OSS Internet Connectivity Setup Script for Windows
REM This script configures VS Code OSS to connect to the internet and access the extension marketplace
REM Run this script from the VS Code OSS project root directory

echo 🚀 Setting up VS Code OSS for internet connectivity...

REM Check if we're in the right directory
if not exist "product.json" (
    echo ❌ Error: Please run this script from the VS Code OSS project root directory
    echo    Expected to find product.json in current directory
    pause
    exit /b 1
)

REM Check Node.js version
echo 📋 Checking Node.js version...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Node.js is not installed
    echo    Please install Node.js v22.15.1 or later from https://nodejs.org
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo ✅ Node.js version: %NODE_VERSION%

REM Install dependencies
echo 📦 Installing dependencies...
call npm install
if errorlevel 1 (
    echo ❌ Error: Failed to install dependencies
    pause
    exit /b 1
)

REM Compile VS Code
echo 🔨 Compiling VS Code...
set NODE_OPTIONS=--max-old-space-size=8192
call npm run compile
if errorlevel 1 (
    echo ❌ Error: Failed to compile VS Code
    pause
    exit /b 1
)

REM Backup original files
echo 💾 Creating backups of original configuration files...
if exist "product.json" copy "product.json" "product.json.backup" >nul
if exist ".vscode\settings.json" copy ".vscode\settings.json" ".vscode\settings.json.backup" >nul

REM Configure product.json
echo ⚙️  Configuring product.json for marketplace access...
(
echo {
echo 	"nameShort": "Code - OSS",
echo 	"nameLong": "Code - OSS",
echo 	"applicationName": "code-oss",
echo 	"dataFolderName": ".vscode-oss",
echo 	"win32MutexName": "vscodeoss",
echo 	"licenseName": "MIT",
echo 	"licenseUrl": "https://github.com/microsoft/vscode/blob/main/LICENSE.txt",
echo 	"serverLicenseUrl": "https://github.com/microsoft/vscode/blob/main/LICENSE.txt",
echo 	"serverGreeting": [],
echo 	"serverLicense": [],
echo 	"serverLicensePrompt": "",
echo 	"serverApplicationName": "code-server-oss",
echo 	"serverDataFolderName": ".vscode-server-oss",
echo 	"tunnelApplicationName": "code-tunnel-oss",
echo 	"win32DirName": "Microsoft Code OSS",
echo 	"win32NameVersion": "Microsoft Code OSS",
echo 	"win32RegValueName": "CodeOSS",
echo 	"win32x64AppId": "{{D77B7E06-80BA-4137-BCF4-654B95CCEBC5}",
echo 	"win32arm64AppId": "{{D1ACE434-89C5-48D1-88D3-E2991DF85475}",
echo 	"win32x64UserAppId": "{{CC6B787D-37A0-49E8-AE24-8559A032BE0C}",
echo 	"win32arm64UserAppId": "{{3AEBF0C8-F733-4AD4-BADE-FDB816D53D7B}",
echo 	"win32AppUserModelId": "Microsoft.CodeOSS",
echo 	"win32ShellNameShort": "C^&ode - OSS",
echo 	"win32TunnelServiceMutex": "vscodeoss-tunnelservice",
echo 	"win32TunnelMutex": "vscodeoss-tunnel",
echo 	"darwinBundleIdentifier": "com.visualstudio.code.oss",
echo 	"darwinProfileUUID": "47827DD9-4734-49A0-AF80-7E19B11495CC",
echo 	"darwinProfilePayloadUUID": "CF808BE7-53F3-46C6-A7E2-7EDB98A5E959",
echo 	"linuxIconName": "code-oss",
echo 	"licenseFileName": "LICENSE.txt",
echo 	"reportIssueUrl": "https://github.com/microsoft/vscode/issues/new",
echo 	"nodejsRepository": "https://nodejs.org",
echo 	"urlProtocol": "code-oss",
echo 	"webviewContentExternalBaseUrlTemplate": "https://{{uuid}}.vscode-cdn.net/insider/ef65ac1ba57f57f2a3961bfe94aa20481caca4c6/out/vs/workbench/contrib/webview/browser/pre/",
echo 	"builtInExtensions": [
echo 		{
echo 			"name": "ms-vscode.js-debug-companion",
echo 			"version": "1.1.3",
echo 			"sha256": "7380a890787452f14b2db7835dfa94de538caf358ebc263f9d46dd68ac52de93",
echo 			"repo": "https://github.com/microsoft/vscode-js-debug-companion",
echo 			"metadata": {
echo 				"id": "99cb0b7f-7354-4278-b8da-6cc79972169d",
echo 				"publisherId": {
echo 					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
echo 					"publisherName": "ms-vscode",
echo 					"displayName": "Microsoft",
echo 					"flags": "verified"
echo 				},
echo 				"publisherDisplayName": "Microsoft"
echo 			}
echo 		},
echo 		{
echo 			"name": "ms-vscode.js-debug",
echo 			"version": "1.104.0",
echo 			"sha256": "856db934294bd8b78769dd91c86904c7e35e356bb05b223a9e4d8eb38cb17ae3",
echo 			"repo": "https://github.com/microsoft/vscode-js-debug",
echo 			"metadata": {
echo 				"id": "25629058-ddac-4e17-abba-74678e126c5d",
echo 				"publisherId": {
echo 					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
echo 					"publisherName": "ms-vscode",
echo 					"displayName": "Microsoft",
echo 					"flags": "verified"
echo 				},
echo 				"publisherDisplayName": "Microsoft"
echo 			}
echo 		},
echo 		{
echo 			"name": "ms-vscode.vscode-js-profile-table",
echo 			"version": "1.0.10",
echo 			"sha256": "7361748ddf9fd09d8a2ed1f2a2d7376a2cf9aae708692820b799708385c38e08",
echo 			"repo": "https://github.com/microsoft/vscode-js-profile-visualizer",
echo 			"metadata": {
echo 				"id": "7e52b41b-71ad-457b-ab7e-0620f1fc4feb",
echo 				"publisherId": {
echo 					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
echo 					"publisherName": "ms-vscode",
echo 					"displayName": "Microsoft",
echo 					"flags": "verified"
echo 				},
echo 				"publisherDisplayName": "Microsoft"
echo 			}
echo 		}
echo 	],
echo 	"extensionsGallery": {
echo 		"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
echo 		"itemUrl": "https://marketplace.visualstudio.com/items",
echo 		"publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
echo 		"resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
echo 		"controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
echo 		"nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
echo 	}
echo }
) > product.json

REM Create .vscode directory and configure settings.json
echo ⚙️  Configuring .vscode\settings.json for internet connectivity...
if not exist ".vscode" mkdir ".vscode"

REM Note: Windows batch files have limitations with complex JSON
REM For now, we'll create a basic settings file and recommend manual configuration
(
echo {
echo 	"http.proxySupport": "on",
echo 	"http.useLocalProxyConfiguration": true,
echo 	"http.fetchAdditionalSupport": true,
echo 	"http.systemCertificates": true,
echo 	"http.experimental.systemCertificatesV2": true,
echo 	"extensions.gallery.serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
echo 	"extensions.gallery.itemUrl": "https://marketplace.visualstudio.com/items",
echo 	"extensions.gallery.publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
echo 	"extensions.gallery.resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
echo 	"extensions.gallery.controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
echo 	"extensions.gallery.nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
echo }
) > .vscode\settings.json

echo ✅ Configuration complete!

REM Test internet connectivity
echo 🌐 Testing internet connectivity...
curl -s --head https://www.google.com >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Internet connectivity test failed, but continuing...
) else (
    echo ✅ Internet connectivity confirmed
)

REM Test marketplace connectivity
echo 🏪 Testing marketplace connectivity...
curl -s --head "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Marketplace connectivity test failed, but continuing...
) else (
    echo ✅ Marketplace connectivity confirmed
)

echo.
echo 🎉 Setup complete! VS Code OSS is now configured for internet connectivity.
echo.
echo 📋 What was configured:
echo    ✅ Dependencies installed
echo    ✅ VS Code compiled
echo    ✅ Marketplace configuration added to product.json
echo    ✅ Internet connectivity settings added to .vscode\settings.json
echo    ✅ HTTP/Network settings configured
echo.
echo 🚀 To run VS Code:
echo    scripts\code.bat
echo.
echo 🔧 To restore original configuration:
echo    copy product.json.backup product.json
echo    copy .vscode\settings.json.backup .vscode\settings.json
echo.
echo 📖 For more information, see SETUP.md
echo.
pause
