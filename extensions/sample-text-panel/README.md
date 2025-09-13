# Sample Text Panel Extension

This VS Code extension automatically opens a sample text panel on the right side when you select a code file.

## Features

- **Automatic Panel Display**: When you open or switch to a code file, a sample text panel automatically appears in the editor area to the right
- **Code File Detection**: The extension recognizes common programming languages including JavaScript, TypeScript, Python, Java, C#, C++, Go, Rust, PHP, Ruby, Swift, and many more
- **Customizable Content**: You can customize the sample text displayed in the panel through VS Code settings
- **Toggle Command**: Use the command palette to manually toggle the panel on/off

## How It Works

1. The extension monitors active editor changes using `vscode.window.onDidChangeActiveTextEditor`
2. When a code file is detected (based on language ID), it creates a webview panel using `vscode.window.createWebviewPanel`
3. The panel is positioned to the right (`vscode.ViewColumn.Beside`) of the current editor
4. When switching to non-code files, the panel automatically closes

## Configuration

You can customize the extension through VS Code settings:

- `sampleTextPanel.enabled`: Enable/disable the automatic panel (default: true)
- `sampleTextPanel.sampleText`: Customize the text displayed in the panel

## Commands

- `Sample Text Panel: Toggle Sample Text Panel`: Manually toggle the panel visibility

## Usage

1. Install and activate the extension
2. Open any code file (e.g., .js, .ts, .py, .java, etc.)
3. The sample text panel will automatically appear on the right
4. Switch to a non-code file (e.g., .txt, .md) and the panel will disappear
5. Switch back to a code file and the panel will reappear

## Technical Details

The extension uses:
- VS Code's Webview API for the panel content
- Editor change event listeners for automatic triggering
- Configuration API for customizable settings
- Language detection based on VS Code's language IDs

## Supported File Types

The extension recognizes these programming languages as "code files":
- JavaScript, TypeScript
- Python, Java, C#, C++, C
- Go, Rust, PHP, Ruby, Swift, Kotlin, Scala, Dart
- HTML, CSS, SCSS, LESS
- JSON, XML, YAML, SQL
- Shell scripts, PowerShell, Batch files
- R, MATLAB, Perl, Lua
- Haskell, Clojure, F#, Visual Basic
- Objective-C, Groovy, Elixir, Erlang
- And more...
