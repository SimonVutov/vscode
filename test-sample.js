/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
// This is a test JavaScript file
// When you open this file, you should see a sample text panel appear on the right

function greetUser(name) {
	console.log(`Hello, ${name}!`);
	return `Welcome, ${name}`;
}

const users = ['Alice', 'Bob', 'Charlie'];
users.forEach(user => {
	greetUser(user);
});

// Try opening different code files to see the panel behavior
// The panel should appear for code files and disappear for non-code files
