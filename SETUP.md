# VS Code OSS Internet Connectivity Setup

This guide explains how to configure VS Code OSS (Open Source Software) to connect to the internet and access the Microsoft extension marketplace.

## Quick Setup (Recommended)

### Option 1: Automated Setup Script
```bash
# Run from VS Code OSS project root
./setup-vscode-internet.sh
```

This script will:
- ✅ Check and install Node.js v22.15.1 (via nvm)
- ✅ Install dependencies (`npm install`)
- ✅ Compile VS Code with increased memory
- ✅ Configure marketplace access
- ✅ Set up internet connectivity
- ✅ Test connectivity

### Option 2: Manual Setup

#### Prerequisites
- Node.js v22.15.1 or later
- npm
- Git

#### Step 1: Install Node.js v22.15.1
```bash
# Using nvm (recommended)
nvm install 22.15.1
nvm use 22.15.1

# Or download from https://nodejs.org
```

#### Step 2: Install Dependencies
```bash
npm install
```

#### Step 3: Compile VS Code
```bash
export NODE_OPTIONS="--max-old-space-size=8192"
npm run compile
```

#### Step 4: Configure Marketplace Access
Add the following to `product.json`:
```json
{
  "extensionsGallery": {
    "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
    "itemUrl": "https://marketplace.visualstudio.com/items",
    "publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
    "resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
    "controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
    "nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
  }
}
```

#### Step 5: Configure Internet Settings
Add the following to `.vscode/settings.json`:
```json
{
  "http.proxySupport": "on",
  "http.useLocalProxyConfiguration": true,
  "http.fetchAdditionalSupport": true,
  "http.systemCertificates": true,
  "http.experimental.systemCertificatesV2": true,
  "extensions.gallery.serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
  "extensions.gallery.itemUrl": "https://marketplace.visualstudio.com/items",
  "extensions.gallery.publisherUrl": "https://marketplace.visualstudio.com/manage/publishers",
  "extensions.gallery.resourceUrlTemplate": "https://{publisher}.gallerycdn.vsassets.io/extensions/{publisher}/{name}/{version}/{assetName}",
  "extensions.gallery.controlUrl": "https://az764295.vo.msecnd.net/extensions/marketplace.json",
  "extensions.gallery.nlsBaseUrl": "https://www.vscode-unpkg.net/_lp"
}
```

#### Step 6: Run VS Code
```bash
./scripts/code.sh
```

## What This Configuration Enables

### ✅ Extension Marketplace
- Search and install extensions
- View extension details and ratings
- Access publisher information
- Download extension assets

### ✅ Internet Features
- GitHub integration (pull requests, issues)
- AI features (GitHub Copilot, chat)
- Package managers (npm, pip, etc.)
- Remote development
- Settings sync
- Live Share collaboration

### ✅ Network Connectivity
- HTTP/HTTPS requests
- Proxy support
- Certificate validation
- DNS resolution

## Configuration Details

### Marketplace URLs Explained
- **serviceUrl**: Main API endpoint for extension queries
- **itemUrl**: Web interface for extension details
- **publisherUrl**: Publisher management interface
- **resourceUrlTemplate**: Template for downloading extension assets
- **controlUrl**: Extension control manifest
- **nlsBaseUrl**: Localization resources

### HTTP Settings Explained
- **proxySupport**: Enable proxy support
- **useLocalProxyConfiguration**: Use system proxy settings
- **fetchAdditionalSupport**: Enhanced fetch capabilities
- **systemCertificates**: Use system SSL certificates
- **systemCertificatesV2**: Experimental certificate support

## Troubleshooting

### Extension Marketplace Not Loading
1. Check internet connectivity: `curl -I https://www.google.com`
2. Test marketplace API: `curl -I "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"`
3. Verify Node.js version: `node --version` (should be v22.15.1+)
4. Check configuration files are properly formatted JSON

### Compilation Issues
1. Increase Node.js memory: `export NODE_OPTIONS="--max-old-space-size=8192"`
2. Clear build cache: `rm -rf out build`
3. Reinstall dependencies: `rm -rf node_modules && npm install`

### Network Issues
1. Check proxy settings in VS Code settings
2. Verify firewall isn't blocking connections
3. Test with different network (mobile hotspot)

## Team Collaboration

### For New Team Members
1. Clone the repository
2. Run `./setup-vscode-internet.sh`
3. Start developing!

### For Existing Team Members
1. Pull latest changes
2. Run `./setup-vscode-internet.sh` to update configuration
3. Restart VS Code

### Configuration Management
- Configuration files are included in the repository
- Changes are automatically applied to all team members
- Backup files are created (`.backup` extension)

## Alternative Setup Methods

### Docker Setup
```dockerfile
FROM node:22.15.1-alpine
WORKDIR /vscode
COPY . .
RUN npm install
RUN export NODE_OPTIONS="--max-old-space-size=8192" && npm run compile
CMD ["./scripts/code.sh"]
```

### VS Code Dev Container
```json
{
  "name": "VS Code OSS",
  "image": "node:22.15.1",
  "postCreateCommand": "./setup-vscode-internet.sh",
  "customizations": {
    "vscode": {
      "extensions": ["ms-vscode.vscode-typescript-next"]
    }
  }
}
```

## Security Considerations

### Marketplace Access
- Uses official Microsoft marketplace URLs
- All connections are HTTPS encrypted
- No authentication required for public extensions

### Network Security
- Respects system proxy settings
- Uses system certificate store
- Follows standard HTTP security practices

## Performance Notes

### Memory Usage
- Compilation requires 8GB+ RAM
- Use `NODE_OPTIONS="--max-old-space-size=8192"`
- Consider using swap space for low-memory systems

### Network Performance
- Extension downloads are cached locally
- Marketplace queries are optimized
- Assets are served from CDN

## Support

### Common Issues
- **Node.js version**: Must be v22.15.1 or later
- **Memory**: Compilation needs 8GB+ RAM
- **Network**: Requires internet access for marketplace
- **Permissions**: Script needs execute permissions

### Getting Help
1. Check this documentation
2. Run the setup script with verbose output
3. Check VS Code logs in Developer Tools
4. Verify network connectivity

## Changelog

### v1.0.0
- Initial setup script
- Complete marketplace configuration
- Internet connectivity settings
- Comprehensive documentation
- Team collaboration support
