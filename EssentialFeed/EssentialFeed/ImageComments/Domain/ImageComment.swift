//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageComment: Equatable {
	let id: UUID
	let message: String
	let createdAt: Date
	let userName: String

	public init(id: UUID, message: String, createdAt: Date, userName: String) {
		self.id = id
		self.message = message
		self.createdAt = createdAt
		self.userName = userName
	}
}
