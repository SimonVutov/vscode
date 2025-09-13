/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// Test file for AI Code Analysis Extension
// This file demonstrates various code patterns for AI summarization

class UserManager {
	constructor() {
		this.users = new Map();
		this.activeUsers = new Set();
	}

	async addUser(userData) {
		try {
			const user = {
				id: this.generateId(),
				name: userData.name,
				email: userData.email,
				createdAt: new Date(),
				isActive: false
			};

			this.users.set(user.id, user);
			return user;
		} catch (error) {
			console.error('Failed to add user:', error);
			throw error;
		}
	}

	activateUser(userId) {
		const user = this.users.get(userId);
		if (user) {
			user.isActive = true;
			this.activeUsers.add(userId);
			this.notifyUserActivation(user);
		}
	}

	generateId() {
		return Math.random().toString(36).substr(2, 9);
	}

	notifyUserActivation(user) {
		console.log(`User ${user.name} has been activated`);
	}

	getActiveUsers() {
		return Array.from(this.activeUsers)
			.map(id => this.users.get(id))
			.filter(user => user && user.isActive);
	}
}

// Usage example
const userManager = new UserManager();

async function demo() {
	const newUser = await userManager.addUser({
		name: 'John Doe',
		email: 'john@example.com'
	});

	userManager.activateUser(newUser.id);

	const activeUsers = userManager.getActiveUsers();
	console.log('Active users:', activeUsers);
}

demo().catch(console.error);
