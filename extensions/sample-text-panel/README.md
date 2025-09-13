# AI Code Analysis Panel Extension

This VS Code extension provides AI-powered code analysis with multiple abstraction levels and smart caching to save API credits.

## Features

- **AI-Powered Analysis**: Get intelligent summaries of your code at different abstraction levels
- **Interactive Slider**: Adjust between 5 levels from high-level overview to complete breakdown
- **Database Storage**: Summaries are stored in a local database to avoid re-running AI analysis and save API tokens
- **Real-time Updates**: Analysis updates automatically when you modify code or switch files
- **Multiple AI Models**: Configurable API endpoint and model selection (OpenAI GPT-3.5/4, etc.)
- **Automatic Panel Display**: Panel appears automatically when you open code files

## How It Works

1. The extension monitors active editor changes using `vscode.window.onDidChangeActiveTextEditor`
2. When a code file is detected (based on language ID), it creates a webview panel using `vscode.window.createWebviewPanel`
3. The panel is positioned to the right (`vscode.ViewColumn.Beside`) of the current editor
4. When switching to non-code files, the panel automatically closes

## Abstraction Levels

The extension provides 5 levels of code analysis:

1. **High-Level Overview**: Single sentence summary of what the code does
2. **Key Components**: Main components and their primary purposes (2-3 sentences)
3. **Functional Summary**: Key functions, classes, and their interactions (paragraph)
4. **Detailed Analysis**: Code structure, logic flow, and implementation details
5. **Complete Breakdown**: Comprehensive analysis including all functions, variables, and technical details

## Configuration

Configure the extension through VS Code settings:

- `sampleTextPanel.enabled`: Enable/disable the automatic panel (default: true)
- `sampleTextPanel.apiKey`: Your AI API key (leave empty for mock responses)
- `sampleTextPanel.apiEndpoint`: AI service endpoint (default: OpenAI)
- `sampleTextPanel.model`: AI model to use (default: gpt-3.5-turbo)

## Database System

- Summaries are automatically stored in `.vscode/ai-analysis-db.json`
- Database entries are keyed by file path and abstraction level
- Database is invalidated when file content changes (using SHA256 hash)
- Saves API tokens by reusing previous analyses
- Fast in-memory access with persistent disk storage

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
