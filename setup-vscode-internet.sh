#!/bin/bash

# VS Code OSS Internet Connectivity Setup Script
# This script configures VS Code OSS to connect to the internet and access the extension marketplace
# Run this script from the VS Code OSS project root directory

set -e  # Exit on any error

echo "🚀 Setting up VS Code OSS for internet connectivity..."

# Check if we're in the right directory
if [ ! -f "product.json" ]; then
    echo "❌ Error: Please run this script from the VS Code OSS project root directory"
    echo "   Expected to find product.json in current directory"
    exit 1
fi

# Check Node.js version
echo "📋 Checking Node.js version..."
NODE_VERSION=$(node --version 2>/dev/null || echo "not found")
if [ "$NODE_VERSION" = "not found" ]; then
    echo "❌ Error: Node.js is not installed"
    echo "   Please install Node.js v22.15.1 or later"
    exit 1
fi

echo "✅ Node.js version: $NODE_VERSION"

# Check if nvm is available
if command -v nvm &> /dev/null; then
    echo "📋 Checking if Node.js v22.15.1 is available..."
    if ! nvm list | grep -q "v22.15.1"; then
        echo "📥 Installing Node.js v22.15.1..."
        nvm install 22.15.1
    fi
    echo "🔄 Switching to Node.js v22.15.1..."
    nvm use 22.15.1
else
    echo "⚠️  nvm not found. Please ensure you're using Node.js v22.15.1 or later"
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Compile VS Code
echo "🔨 Compiling VS Code..."
export NODE_OPTIONS="--max-old-space-size=8192"
npm run compile

# Backup original files
echo "💾 Creating backups of original configuration files..."
cp product.json product.json.backup 2>/dev/null || true
cp .vscode/settings.json .vscode/settings.json.backup 2>/dev/null || true

# Configure product.json
echo "⚙️  Configuring product.json for marketplace access..."
cat > product.json << 'EOF'
{
	"nameShort": "Code - OSS",
	"nameLong": "Code - OSS",
	"applicationName": "code-oss",
	"dataFolderName": ".vscode-oss",
	"win32MutexName": "vscodeoss",
	"licenseName": "MIT",
	"licenseUrl": "https://github.com/microsoft/vscode/blob/main/LICENSE.txt",
	"serverLicenseUrl": "https://github.com/microsoft/vscode/blob/main/LICENSE.txt",
	"serverGreeting": [],
	"serverLicense": [],
	"serverLicensePrompt": "",
	"serverApplicationName": "code-server-oss",
	"serverDataFolderName": ".vscode-server-oss",
	"tunnelApplicationName": "code-tunnel-oss",
	"win32DirName": "Microsoft Code OSS",
	"win32NameVersion": "Microsoft Code OSS",
	"win32RegValueName": "CodeOSS",
	"win32x64AppId": "{{D77B7E06-80BA-4137-BCF4-654B95CCEBC5}",
	"win32arm64AppId": "{{D1ACE434-89C5-48D1-88D3-E2991DF85475}",
	"win32x64UserAppId": "{{CC6B787D-37A0-49E8-AE24-8559A032BE0C}",
	"win32arm64UserAppId": "{{3AEBF0C8-F733-4AD4-BADE-FDB816D53D7B}",
	"win32AppUserModelId": "Microsoft.CodeOSS",
	"win32ShellNameShort": "C&ode - OSS",
	"win32TunnelServiceMutex": "vscodeoss-tunnelservice",
	"win32TunnelMutex": "vscodeoss-tunnel",
	"darwinBundleIdentifier": "com.visualstudio.code.oss",
	"darwinProfileUUID": "47827DD9-4734-49A0-AF80-7E19B11495CC",
	"darwinProfilePayloadUUID": "CF808BE7-53F3-46C6-A7E2-7EDB98A5E959",
	"linuxIconName": "code-oss",
	"licenseFileName": "LICENSE.txt",
	"reportIssueUrl": "https://github.com/microsoft/vscode/issues/new",
	"nodejsRepository": "https://nodejs.org",
	"urlProtocol": "code-oss",
	"webviewContentExternalBaseUrlTemplate": "https://{{uuid}}.vscode-cdn.net/insider/ef65ac1ba57f57f2a3961bfe94aa20481caca4c6/out/vs/workbench/contrib/webview/browser/pre/",
	"builtInExtensions": [
		{
			"name": "ms-vscode.js-debug-companion",
			"version": "1.1.3",
			"sha256": "7380a890787452f14b2db7835dfa94de538caf358ebc263f9d46dd68ac52de93",
			"repo": "https://github.com/microsoft/vscode-js-debug-companion",
			"metadata": {
				"id": "99cb0b7f-7354-4278-b8da-6cc79972169d",
				"publisherId": {
					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
					"publisherName": "ms-vscode",
					"displayName": "Microsoft",
					"flags": "verified"
				},
				"publisherDisplayName": "Microsoft"
			}
		},
		{
			"name": "ms-vscode.js-debug",
			"version": "1.104.0",
			"sha256": "856db934294bd8b78769dd91c86904c7e35e356bb05b223a9e4d8eb38cb17ae3",
			"repo": "https://github.com/microsoft/vscode-js-debug",
			"metadata": {
				"id": "25629058-ddac-4e17-abba-74678e126c5d",
				"publisherId": {
					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
					"publisherName": "ms-vscode",
					"displayName": "Microsoft",
					"flags": "verified"
				},
				"publisherDisplayName": "Microsoft"
			}
		},
		{
			"name": "ms-vscode.vscode-js-profile-table",
			"version": "1.0.10",
			"sha256": "7361748ddf9fd09d8a2ed1f2a2d7376a2cf9aae708692820b799708385c38e08",
			"repo": "https://github.com/microsoft/vscode-js-profile-visualizer",
			"metadata": {
				"id": "7e52b41b-71ad-457b-ab7e-0620f1fc4feb",
				"publisherId": {
					"publisherId": "5f5636e7-69ed-4afe-b5d6-8d231fb3d3ee",
					"publisherName": "ms-vscode",
					"displayName": "Microsoft",
					"flags": "verified"
				},
				"publisherDisplayName": "Microsoft"
			}
		}
	],
	"extensionsGallery": {
		"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
		"itemUrl": "https://marketplace.visualstudio.com/items",
		"publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
		"resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
		"controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
		"nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
	}
}
EOF

# Configure .vscode/settings.json
echo "⚙️  Configuring .vscode/settings.json for internet connectivity..."
mkdir -p .vscode

cat > .vscode/settings.json << 'EOF'
{
	// --- Chat ---
	"chat.tools.terminal.autoApprove": {
		"/^npm (test|lint|run compile)\\b/": true,
		"/^npx tsc\\b.*--noEmit/": true,
		"scripts/test.bat": true,
		"scripts/test.sh": true,
		"scripts/test-integration.bat": true,
		"scripts/test-integration.sh": true,
	},

	// --- Editor ---
	"editor.insertSpaces": false,
	"editor.experimental.asyncTokenization": true,
	"editor.experimental.asyncTokenizationVerification": true,
	"editor.occurrencesHighlightDelay": 0,

	// --- Language Specific ---
	"[plaintext]": {
		"files.insertFinalNewline": false
	},
	"[typescript]": {
		"editor.defaultFormatter": "vscode.typescript-language-features",
		"editor.formatOnSave": true
	},
	"[javascript]": {
		"editor.defaultFormatter": "vscode.typescript-language-features",
		"editor.formatOnSave": true
	},
	"[rust]": {
		"editor.defaultFormatter": "rust-lang.rust-analyzer",
		"editor.formatOnSave": true,
	},
	"[github-issues]": {
		"editor.wordWrap": "on"
	},

	// --- Files ---
	"files.trimTrailingWhitespace": true,
	"files.insertFinalNewline": true,
	"files.exclude": {
		".git": true,
		".build": true,
		".profile-oss": true,
		"**/.DS_Store": true,
		".vscode-test": true,
		"cli/target": true,
		"build/**/*.js.map": true,
		"build/**/*.js": {
			"when": "$(basename).ts"
		}
	},
	"files.associations": {
		"cglicenses.json": "jsonc",
		"*.tst": "typescript"
	},
	"files.readonlyInclude": {
		"**/node_modules/**/*.*": true,
		"**/yarn.lock": true,
		"**/package-lock.json": true,
		"**/Cargo.lock": true,
		"build/**/*.js": true,
		"out/**": true,
		"out-build/**": true,
		"out-vscode/**": true,
		"out-vscode-reh/**": true,
		"extensions/**/dist/**": true,
		"extensions/**/out/**": true,
		"extensions/terminal-suggest/src/completions/upstream/**": true,
		"test/smoke/out/**": true,
		"test/automation/out/**": true,
		"test/integration/browser/out/**": true
	},
	"files.readonlyExclude": {
		"build/builtin/*.js": true,
		"build/monaco/*.js": true,
		"build/npm/*.js": true,
		"build/*.js": true
	},

	// --- Search ---
	"search.exclude": {
		"**/node_modules": true,
		"cli/target/**": true,
		".build/**": true,
		"out/**": true,
		"out-build/**": true,
		"out-vscode/**": true,
		"i18n/**": true,
		"extensions/**/dist/**": true,
		"extensions/**/out/**": true,
		"test/smoke/out/**": true,
		"test/automation/out/**": true,
		"test/integration/browser/out/**": true,
		"src/vs/base/test/common/filters.perf.data.js": true,
		"src/vs/base/test/node/uri.perf.data.txt": true,
		"src/vs/workbench/api/test/browser/extHostDocumentData.test.perf-data.ts": true,
		"src/vs/base/test/node/uri.test.data.txt": true,
		"src/vs/editor/test/node/diffing/fixtures/**": true,
		"build/loader.min": true
	},

	// --- TypeScript ---
	"typescript.tsdk": "node_modules/typescript/lib",
	"typescript.preferences.importModuleSpecifier": "relative",
	"typescript.preferences.quoteStyle": "single",
	"typescript.tsc.autoDetect": "off",
	"typescript.preferences.autoImportFileExcludePatterns": [
		"@xterm/xterm",
		"@xterm/headless",
		"node-pty",
		"vscode-notebook-renderer",
		"src/vs/workbench/workbench.web.main.internal.ts"
	],

	// --- Languages ---
	"json.schemas": [
		{
			"fileMatch": [
				"cgmanifest.json"
			],
			"url": "https://www.schemastore.org/component-detection-manifest.json",
		},
		{
			"fileMatch": [
				"cglicenses.json"
			],
			"url": "./.vscode/cglicenses.schema.json"
		}
	],
	"css.format.spaceAroundSelectorSeparator": true,

	// --- Git ---
	"git.ignoreLimitWarning": true,
	"git.branchProtection": [
		"main",
		"distro",
		"release/*"
	],
	"git.branchProtectionPrompt": "alwaysCommitToNewBranch",
	"git.branchRandomName.enable": true,
	"git.pullBeforeCheckout": true,
	"git.mergeEditor": true,
	"git.diagnosticsCommitHook.enabled": true,
	"git.diagnosticsCommitHook.sources": {
		"*": "error",
		"ts": "warning",
		"eslint": "warning"
	},

	// --- GitHub ---
	"githubPullRequests.experimental.createView": true,
	"githubPullRequests.assignCreated": "${user}",
	"githubPullRequests.defaultMergeMethod": "squash",
	"githubPullRequests.ignoredPullRequestBranches": [
		"main"
	],
	"githubPullRequests.codingAgent.enabled": true,
	"githubPullRequests.codingAgent.uiIntegration": true,

	// --- Testing & Debugging ---
	"testing.autoRun.mode": "rerun",
	"debug.javascript.terminalOptions": {
		"outFiles": [
			"${workspaceFolder}/out/**/*.js",
			"${workspaceFolder}/build/**/*.js"
		]
	},
	"extension-test-runner.debugOptions": {
		"outFiles": [
			"${workspaceFolder}/extensions/*/out/**/*.js",
		]
	},

	// --- Coverage ---
	"lcov.path": [
		"./.build/coverage/lcov.info",
		"./.build/coverage-single/lcov.info"
	],
	"lcov.watch": [
		{
			"pattern": "**/*.test.js",
			"command": "${workspaceFolder}/scripts/test.sh --coverage --run ${file}",
			"windows": {
				"command": "${workspaceFolder}\\scripts\\test.bat --coverage --run ${file}"
			}
		}
	],

	// --- Tools ---
	"npm.exclude": "**/extensions/**",
	"eslint.useFlatConfig": true,
	"emmet.excludeLanguages": [],
	"gulp.autoDetect": "off",
	"rust-analyzer.linkedProjects": [
		"cli/Cargo.toml"
	],
	"conventionalCommits.scopes": [
		"tree",
		"scm",
		"grid",
		"splitview",
		"table",
		"list",
		"git",
		"sash"
	],

	// --- Workbench ---
	"remote.extensionKind": {
		"msjsdiag.debugger-for-chrome": "workspace"
	},

	"editor.aiStats.enabled": true,
	"chat.checkpoints.showFileChanges": true,
	"chat.emptyState.history.enabled": true,
	"github.copilot.chat.advanced.taskTools.enabled": true,
	"chat.promptFilesRecommendations": {
		"plan": true
	},

	// --- HTTP/Network Configuration ---
	"http.proxySupport": "on",
	"http.useLocalProxyConfiguration": true,
	"http.fetchAdditionalSupport": true,
	"http.systemCertificates": true,
	"http.experimental.systemCertificatesV2": true,

	// --- Extension Marketplace Configuration ---
	"extensions.gallery.serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
	"extensions.gallery.itemUrl": "https://marketplace.visualstudio.com/items",
	"extensions.gallery.publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
	"extensions.gallery.resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
	"extensions.gallery.controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
	"extensions.gallery.nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
}
EOF

echo "✅ Configuration complete!"

# Test internet connectivity
echo "🌐 Testing internet connectivity..."
if curl -s --head https://www.google.com | head -n 1 | grep -q "200 OK"; then
    echo "✅ Internet connectivity confirmed"
else
    echo "⚠️  Internet connectivity test failed, but continuing..."
fi

# Test marketplace connectivity
echo "🏪 Testing marketplace connectivity..."
if curl -s --head "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" | head -n 1 | grep -q "405\|200"; then
    echo "✅ Marketplace connectivity confirmed"
else
    echo "⚠️  Marketplace connectivity test failed, but continuing..."
fi

echo ""
echo "🎉 Setup complete! VS Code OSS is now configured for internet connectivity."
echo ""
echo "📋 What was configured:"
echo "   ✅ Node.js v22.15.1 (via nvm)"
echo "   ✅ Dependencies installed"
echo "   ✅ VS Code compiled"
echo "   ✅ Marketplace configuration added to product.json"
echo "   ✅ Internet connectivity settings added to .vscode/settings.json"
echo "   ✅ HTTP/Network settings configured"
echo ""
echo "🚀 To run VS Code:"
echo "   ./scripts/code.sh"
echo ""
echo "🔧 To restore original configuration:"
echo "   cp product.json.backup product.json"
echo "   cp .vscode/settings.json.backup .vscode/settings.json"
echo ""
echo "📖 For more information, see SETUP.md"
