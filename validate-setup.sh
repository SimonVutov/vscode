#!/bin/bash

# VS Code OSS Setup Validation Script
# This script validates that VS Code OSS is properly configured for internet connectivity

set -e

echo "🔍 Validating VS Code OSS internet connectivity setup..."

# Check if we're in the right directory
if [ ! -f "product.json" ]; then
    echo "❌ Error: Please run this script from the VS Code OSS project root directory"
    exit 1
fi

# Check Node.js version
echo "📋 Checking Node.js version..."
NODE_VERSION=$(node --version 2>/dev/null || echo "not found")
if [ "$NODE_VERSION" = "not found" ]; then
    echo "❌ Node.js is not installed"
    exit 1
fi

echo "✅ Node.js version: $NODE_VERSION"

# Check if Node.js version is sufficient
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_MAJOR" -lt 22 ]; then
    echo "⚠️  Warning: Node.js version $NODE_VERSION may not be sufficient. Recommended: v22.15.1+"
fi

# Check if dependencies are installed
echo "📦 Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo "❌ Dependencies not installed. Run: npm install"
    exit 1
fi
echo "✅ Dependencies installed"

# Check if VS Code is compiled
echo "🔨 Checking VS Code compilation..."
if [ ! -d "out" ]; then
    echo "❌ VS Code not compiled. Run: npm run compile"
    exit 1
fi
echo "✅ VS Code compiled"

# Check product.json configuration
echo "⚙️  Checking product.json configuration..."
if ! grep -q "extensionsGallery" product.json; then
    echo "❌ Marketplace configuration missing from product.json"
    exit 1
fi

if ! grep -q "serviceUrl" product.json; then
    echo "❌ Marketplace serviceUrl missing from product.json"
    exit 1
fi

echo "✅ Marketplace configuration present in product.json"

# Check .vscode/settings.json configuration
echo "⚙️  Checking .vscode/settings.json configuration..."
if [ ! -f ".vscode/settings.json" ]; then
    echo "❌ .vscode/settings.json not found"
    exit 1
fi

if ! grep -q "http.proxySupport" .vscode/settings.json; then
    echo "❌ HTTP configuration missing from .vscode/settings.json"
    exit 1
fi

if ! grep -q "extensions.gallery.serviceUrl" .vscode/settings.json; then
    echo "❌ Extension gallery configuration missing from .vscode/settings.json"
    exit 1
fi

echo "✅ Internet connectivity configuration present in .vscode/settings.json"

# Test internet connectivity
echo "🌐 Testing internet connectivity..."
if curl -s --head https://www.google.com | head -n 1 | grep -q "200 OK"; then
    echo "✅ Internet connectivity confirmed"
else
    echo "⚠️  Internet connectivity test failed"
fi

# Test marketplace connectivity
echo "🏪 Testing marketplace connectivity..."
if curl -s --head "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" | head -n 1 | grep -q "405\|200"; then
    echo "✅ Marketplace connectivity confirmed"
else
    echo "⚠️  Marketplace connectivity test failed"
fi

# Test marketplace API with proper request
echo "🔍 Testing marketplace API..."
API_RESPONSE=$(curl -s -X POST "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery?api-version=3.0-preview.1" \
    -H "Content-Type: application/json" \
    -d '{"filters":[{"criteria":[{"filterType":8,"value":"Microsoft.VisualStudio.Code"}],"pageNumber":1,"pageSize":1,"sortBy":0,"sortOrder":0}],"assetTypes":[],"flags":914}' 2>/dev/null)

if echo "$API_RESPONSE" | grep -q "results"; then
    echo "✅ Marketplace API responding correctly"
else
    echo "⚠️  Marketplace API test failed"
fi

echo ""
echo "🎉 Validation complete!"
echo ""
echo "📋 Summary:"
echo "   ✅ Node.js: $NODE_VERSION"
echo "   ✅ Dependencies: Installed"
echo "   ✅ VS Code: Compiled"
echo "   ✅ Marketplace: Configured"
echo "   ✅ Internet: Configured"
echo ""
echo "🚀 Ready to run VS Code:"
echo "   ./scripts/code.sh"
echo ""
echo "📖 For troubleshooting, see SETUP.md"
