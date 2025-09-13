/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import * as vscode from 'vscode';

const SAMPLE_TEXT_VIEW_TYPE = 'sampleTextPanel.view';

// List of programming language IDs that we consider as "code files"
const CODE_LANGUAGES = new Set([
	'javascript', 'typescript', 'python', 'java', 'csharp', 'cpp', 'c',
	'go', 'rust', 'php', 'ruby', 'swift', 'kotlin', 'scala', 'dart',
	'html', 'css', 'scss', 'less', 'json', 'xml', 'yaml', 'sql',
	'shell', 'powershell', 'batch', 'dockerfile', 'makefile',
	'r', 'matlab', 'perl', 'lua', 'haskell', 'clojure', 'fsharp',
	'vb', 'objective-c', 'groovy', 'elixir', 'erlang'
]);

let currentPanel: vscode.WebviewPanel | undefined = undefined;
let debounceTimer: NodeJS.Timeout | undefined = undefined;

export function activate(context: vscode.ExtensionContext) {

	// Function to check if a document is a code file
	function isCodeFile(document: vscode.TextDocument | undefined): boolean {
		if (!document) {
			return false;
		}

		return CODE_LANGUAGES.has(document.languageId);
	}

	// Function to get sample text from configuration
	function getSampleText(): string {
		const config = vscode.workspace.getConfiguration('sampleTextPanel');
		return config.get('sampleText', '// Sample text not configured');
	}

	// Function to create or show the sample text panel
	function showSampleTextPanel() {
		const config = vscode.workspace.getConfiguration('sampleTextPanel');
		const enabled = config.get('enabled', true);

		if (!enabled) {
			return;
		}

		if (currentPanel) {
			// If panel exists, don't recreate it
			return;
		}

		// Create a new webview panel
		currentPanel = vscode.window.createWebviewPanel(
			SAMPLE_TEXT_VIEW_TYPE,
			'Sample Text',
			{ viewColumn: vscode.ViewColumn.Beside, preserveFocus: true },
			{
				enableScripts: true,
				retainContextWhenHidden: true
			}
		);

		// Set the webview content
		updatePanelContent();

		// Handle panel disposal
		currentPanel.onDidDispose(() => {
			currentPanel = undefined;
		}, null, context.subscriptions);

		// Update content when configuration changes (only register once)
		const configChangeListener = vscode.workspace.onDidChangeConfiguration(e => {
			if (e.affectsConfiguration('sampleTextPanel.sampleText') && currentPanel) {
				updatePanelContent();
			}
		});
		context.subscriptions.push(configChangeListener);
	}

	// Function to hide the sample text panel
	function hideSampleTextPanel() {
		if (currentPanel) {
			currentPanel.dispose();
			currentPanel = undefined;
		}
	}

	// Function to update panel content
	function updatePanelContent() {
		if (!currentPanel) {
			return;
		}

		const sampleText = getSampleText();

		currentPanel.webview.html = `
			<!DOCTYPE html>
			<html lang="en">
			<head>
				<meta charset="UTF-8">
				<meta name="viewport" content="width=device-width, initial-scale=1.0">
				<title>Sample Text</title>
				<style>
					body {
						font-family: var(--vscode-font-family);
						font-size: var(--vscode-font-size);
						color: var(--vscode-foreground);
						background-color: var(--vscode-editor-background);
						padding: 16px;
						margin: 0;
						line-height: 1.6;
					}

					.container {
						max-width: 100%;
						margin: 0 auto;
					}

					.header {
						border-bottom: 1px solid var(--vscode-panel-border);
						padding-bottom: 12px;
						margin-bottom: 16px;
					}

					.header h1 {
						margin: 0;
						font-size: 1.2em;
						font-weight: 600;
						color: var(--vscode-panelTitle-activeForeground);
					}

					.content {
						white-space: pre-wrap;
						font-family: var(--vscode-editor-font-family);
						font-size: var(--vscode-editor-font-size);
						background-color: var(--vscode-textCodeBlock-background);
						border: 1px solid var(--vscode-panel-border);
						border-radius: 4px;
						padding: 16px;
						overflow-x: auto;
					}

					.footer {
						margin-top: 16px;
						padding-top: 12px;
						border-top: 1px solid var(--vscode-panel-border);
						font-size: 0.9em;
						color: var(--vscode-descriptionForeground);
					}
				</style>
			</head>
			<body>
				<div class="container">
					<div class="header">
						<h1>Sample Text Panel</h1>
					</div>
					<div class="content">${escapeHtml(sampleText)}</div>
					<div class="footer">
						This panel appears automatically when you select a code file.<br>
						You can customize the text in VS Code settings under "Sample Text Panel".
					</div>
				</div>
			</body>
			</html>
		`;
	}

	// Function to escape HTML
	function escapeHtml(text: string): string {
		return text
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#39;');
	}

	// Debounced function to handle editor changes
	function handleEditorChange(editor: vscode.TextEditor | undefined) {
		// Clear any existing timer
		if (debounceTimer) {
			clearTimeout(debounceTimer);
		}

		// Set a new timer to debounce rapid changes
		debounceTimer = setTimeout(() => {
			const shouldShowPanel = editor && isCodeFile(editor.document);
			const panelExists = currentPanel !== undefined;
			const panelCurrentlyVisible = currentPanel && currentPanel.visible;

			if (shouldShowPanel && !panelExists) {
				// Only create panel if it doesn't exist at all
				showSampleTextPanel();
			} else if (shouldShowPanel && panelExists && !panelCurrentlyVisible) {
				// Reveal existing panel without focus
				if (currentPanel) {
					currentPanel.reveal(vscode.ViewColumn.Beside, true);
				}
			} else if (!shouldShowPanel && panelCurrentlyVisible) {
				// Hide panel when switching away from code files
				hideSampleTextPanel();
			}
			// If both are code files or both are non-code files, do nothing
		}, 200); // Longer debounce for more stability
	}

	// Listen for active editor changes
	vscode.window.onDidChangeActiveTextEditor(handleEditorChange, null, context.subscriptions);

	// Check current editor on activation
	if (vscode.window.activeTextEditor && isCodeFile(vscode.window.activeTextEditor.document)) {
		showSampleTextPanel();
	}

	// Register command to toggle the panel
	const toggleCommand = vscode.commands.registerCommand('sampleTextPanel.toggle', () => {
		if (currentPanel) {
			hideSampleTextPanel();
		} else {
			showSampleTextPanel();
		}
	});

	context.subscriptions.push(toggleCommand);

	// Register webview panel serializer for persistence
	vscode.window.registerWebviewPanelSerializer(SAMPLE_TEXT_VIEW_TYPE, {
		async deserializeWebviewPanel(webviewPanel: vscode.WebviewPanel, state: any) {
			currentPanel = webviewPanel;
			updatePanelContent();

			// Re-register disposal handler
			currentPanel.onDidDispose(() => {
				currentPanel = undefined;
			});
		}
	});
}

export function deactivate() {
	// Clean up resources when extension is deactivated
	if (debounceTimer) {
		clearTimeout(debounceTimer);
	}
}
