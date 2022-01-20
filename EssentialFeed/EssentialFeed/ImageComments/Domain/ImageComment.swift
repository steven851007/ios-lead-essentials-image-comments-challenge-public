//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageComment: Hashable {
	public let id: UUID
	public let message: String
	public let createdAt: Date
	public let userName: String

	public init(id: UUID, message: String, createdAt: Date, userName: String) {
		self.id = id
		self.message = message
		self.createdAt = createdAt
		self.userName = userName
	}
}
