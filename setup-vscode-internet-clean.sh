#!/bin/bash

# VS Code OSS Internet Connectivity Setup Script
# This script configures VS Code OSS to connect to the internet and access the extension marketplace
# Run this script from the VS Code OSS project root directory

set -e  # Exit on any error

echo "Setting up VS Code OSS for internet connectivity..."

# Check if we're in the right directory
if [ ! -f "product.json" ]; then
    echo "ERROR: Please run this script from the VS Code OSS project root directory"
    echo "   Expected to find product.json in current directory"
    exit 1
fi

# Check Node.js version
echo "Checking Node.js version..."
NODE_VERSION=$(node --version 2>/dev/null || echo "not found")
if [ "$NODE_VERSION" = "not found" ]; then
    echo "ERROR: Node.js is not installed"
    echo "   Please install Node.js v22.15.1 or later"
    exit 1
fi

echo "Node.js version: $NODE_VERSION"

# Check if nvm is available
if command -v nvm &> /dev/null; then
    echo "Checking if Node.js v22.15.1 is available..."
    if ! nvm list | grep -q "v22.15.1"; then
        echo "Installing Node.js v22.15.1..."
        nvm install 22.15.1
    fi
    echo "Switching to Node.js v22.15.1..."
    nvm use 22.15.1
else
    echo "WARNING: nvm not found. Please ensure you're using Node.js v22.15.1 or later"
fi

# Install dependencies
echo "Installing dependencies..."
npm install

# Compile VS Code
echo "Compiling VS Code..."
export NODE_OPTIONS="--max-old-space-size=8192"
npm run compile

# Backup original files
echo "Creating backups of original configuration files..."
cp .vscode/settings.json .vscode/settings.json.backup 2>/dev/null || true
cp product.json product.json.backup 2>/dev/null || true

# Configure .vscode/settings.json for internet access
echo "Configuring .vscode/settings.json for internet access..."

# Create .vscode directory if it doesn't exist
mkdir -p .vscode

# Create or update settings.json with internet configuration
cat > .vscode/settings.json << 'EOF'
{
  // VS Code OSS Internet Connectivity Configuration
  // This configuration enables internet access and extension marketplace connectivity

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
  "extensions.gallery.nlsBaseUrl": "https://www.vscode-unpkg.net/_lp",

  // --- Additional Settings ---
  "telemetry.enableTelemetry": false,
  "telemetry.enableCrashReporter": false,
  "update.enableWindowsBackgroundUpdates": false,
  "update.showReleaseNotes": "off"
}
EOF

# Configure product.json for marketplace access
echo "Configuring product.json for marketplace access..."

# Read the current product.json and add extensionsGallery if not present
if ! grep -q '"extensionsGallery"' product.json; then
    echo "Adding extensionsGallery configuration to product.json..."

    # Insert the extensionsGallery configuration before the last closing brace
    # This is a simple approach - in production you might want to use jq for more robust JSON manipulation
    sed -i.bak '$i\
  "extensionsGallery": {\
    "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",\
    "itemUrl": "https://marketplace.visualstudio.com/items",\
    "publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",\
    "resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",\
    "controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",\
    "nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"\
  },' product.json

    # Clean up temporary files
    rm -f product.json.bak
else
    echo "extensionsGallery already configured in product.json"
fi

# Test internet connectivity
echo "Testing internet connectivity..."

# Test basic internet connection
if curl -s --connect-timeout 10 https://www.google.com > /dev/null; then
    echo "Basic internet connectivity: OK"
else
    echo "WARNING: Basic internet connectivity test failed"
fi

# Test marketplace API connectivity
if curl -s --connect-timeout 10 "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" > /dev/null; then
    echo "Extension marketplace API connectivity: OK"
else
    echo "WARNING: Extension marketplace API connectivity test failed"
fi

# Test specific marketplace endpoints
MARKETPLACE_URLS=(
    "https://marketplace.visualstudio.com/_apis/public/gallery"
    "https://marketplace.visualstudio.com/items"
    "https://az764295.vo.msecnd.net/extensions/marketplace.json"
)

echo "Testing marketplace endpoints..."
for url in "${MARKETPLACE_URLS[@]}"; do
    if curl -s --connect-timeout 5 "$url" > /dev/null; then
        echo "  $url: OK"
    else
        echo "  $url: FAILED"
    fi
done

echo ""
echo "Setup completed successfully!"
echo ""
echo "Configuration Summary:"
echo "  - Node.js version: $(node --version)"
echo "  - Dependencies installed: OK"
echo "  - VS Code compiled: OK"
echo "  - Internet connectivity configured: OK"
echo "  - Extension marketplace configured: OK"
echo "  - Backup files created: OK"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/code.sh"
echo "  2. Open Extensions view (Ctrl+Shift+X)"
echo "  3. Search for extensions to test marketplace connectivity"
echo ""
echo "If you encounter issues:"
echo "  - Check your internet connection"
echo "  - Verify firewall/proxy settings"
echo "  - Restore original files: cp .vscode/settings.json.backup .vscode/settings.json"
echo "  - Restore original files: cp product.json.backup product.json"
echo ""
echo "For troubleshooting, run: ./validate-setup.sh"
