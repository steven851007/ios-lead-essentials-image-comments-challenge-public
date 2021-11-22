//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
	var isAny200: Bool {
		return 200 <= statusCode && statusCode < 300
	}
}

final public class ImageCommentsMapper {
	private struct Root: Decodable {
		private let items: [RemoteImageComment]

		private struct RemoteImageComment: Decodable {
			let id: UUID
			let message: String
			let created_at: Date
			let author: Author
		}

		private struct Author: Decodable {
			let username: String
		}

		var imageComments: [ImageComment] {
			items.map { ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, userName: $0.author.username) }
		}
	}

	public enum Error: Swift.Error {
		case invalidData
	}

	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		guard response.isAny200, let root = try? decoder.decode(Root.self, from: data) else {
			throw Error.invalidData
		}

		return root.imageComments
	}
}
