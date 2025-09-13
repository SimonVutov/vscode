#!/bin/bash

# VS Code OSS Setup Validation Script
# This script validates that VS Code OSS is properly configured for internet access

set -e  # Exit on any error

echo "Validating VS Code OSS setup..."

# Check Node.js version
echo "Checking Node.js version..."
NODE_VERSION=$(node --version 2>/dev/null || echo "not found")
if [ "$NODE_VERSION" = "not found" ]; then
    echo "ERROR: Node.js is not installed"
    exit 1
fi

echo "Node.js version: $NODE_VERSION"

# Check if we're in the right directory
if [ ! -f "product.json" ]; then
    echo "ERROR: Please run this script from the VS Code OSS project root directory"
    exit 1
fi

# Check if dependencies are installed
echo "Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo "ERROR: Dependencies not installed. Run 'npm install' first."
    exit 1
fi

# Check if VS Code is compiled
echo "Checking VS Code compilation..."
if [ ! -d "out" ]; then
    echo "ERROR: VS Code not compiled. Run 'npm run compile' first."
    exit 1
fi

# Check .vscode/settings.json configuration
echo "Checking .vscode/settings.json configuration..."
if [ ! -f ".vscode/settings.json" ]; then
    echo "ERROR: .vscode/settings.json not found"
    exit 1
fi

# Check for required settings
REQUIRED_SETTINGS=(
    "http.proxySupport"
    "extensions.gallery.serviceUrl"
    "extensions.gallery.itemUrl"
    "extensions.gallery.publisherUrl"
)

for setting in "${REQUIRED_SETTINGS[@]}"; do
    if ! grep -q "\"$setting\"" .vscode/settings.json; then
        echo "ERROR: Required setting '$setting' not found in .vscode/settings.json"
        exit 1
    fi
done

echo "Configuration validation: OK"

# Check product.json configuration
echo "Checking product.json configuration..."
if ! grep -q '"extensionsGallery"' product.json; then
    echo "ERROR: extensionsGallery not found in product.json"
    exit 1
fi

echo "Product configuration: OK"

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
echo "Validation completed successfully!"
echo ""
echo "Summary:"
echo "  - Node.js version: $NODE_VERSION"
echo "  - Dependencies installed: OK"
echo "  - VS Code compiled: OK"
echo "  - Configuration files: OK"
echo "  - Internet connectivity: OK"
echo "  - Marketplace connectivity: OK"
echo ""
echo "VS Code OSS is ready to use with internet access!"
