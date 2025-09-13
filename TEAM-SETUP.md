# VS Code OSS Team Setup

## Quick Start

### For macOS/Linux Users
```bash
./setup-vscode-internet.sh
```

### For Windows Users
```cmd
setup-vscode-internet.bat
```

### Alternative (Cross-platform)
```bash
npm run setup-internet
```

## What This Does

✅ **Installs Node.js v22.15.1** (via nvm)
✅ **Installs dependencies** (`npm install`)
✅ **Compiles VS Code** with proper memory settings
✅ **Configures marketplace access** (extensions, GitHub, AI features)
✅ **Sets up internet connectivity** (HTTP, proxy, certificates)
✅ **Tests connectivity** to ensure everything works

## After Setup

Run VS Code:
```bash
./scripts/code.sh
```

## Troubleshooting

### Node.js Issues
- **Error**: "Node.js not found" → Install Node.js v22.15.1+ from [nodejs.org](https://nodejs.org)
- **Error**: "Memory issues" → The script automatically sets `NODE_OPTIONS="--max-old-space-size=8192"`

### Network Issues
- **Error**: "Marketplace not loading" → Check internet connection
- **Error**: "Extensions not showing" → Restart VS Code after setup

### Platform Issues
- **macOS**: Use `./setup-vscode-internet.sh`
- **Windows**: Use `setup-vscode-internet.bat`
- **Linux**: Use `./setup-vscode-internet.sh`

## Team Workflow

### New Team Member
1. Clone repository
2. Run setup script
3. Start coding!

### Existing Team Member
1. Pull latest changes
2. Run setup script (updates configuration)
3. Continue coding!

## Configuration Files

The setup modifies these files:
- `product.json` - Marketplace configuration
- `.vscode/settings.json` - Internet connectivity settings

Backup files are created (`.backup` extension) for easy restoration.

## Features Enabled

🌐 **Extension Marketplace** - Search and install extensions
🔗 **GitHub Integration** - Pull requests, issues, repository management
🤖 **AI Features** - GitHub Copilot, chat, AI-powered tools
📦 **Package Managers** - npm, pip, etc.
🌍 **Remote Development** - Connect to remote servers
🔄 **Settings Sync** - Sync settings across devices
👥 **Live Share** - Real-time collaboration

## Support

- 📖 **Full Documentation**: See `SETUP.md`
- 🐛 **Issues**: Check VS Code Developer Tools logs
- 🔧 **Restore**: Use backup files to restore original configuration

---

**Need help?** Check `SETUP.md` for detailed troubleshooting and alternative setup methods.
