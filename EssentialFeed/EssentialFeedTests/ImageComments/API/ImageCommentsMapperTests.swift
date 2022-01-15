//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
		let json = makeItemsJSON([])
		let samples = [100, 199, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsErrorOnAny2xxHTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)
		let samples = [200, 220, 260, 299]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
			)
		}
	}

	func test_map_deliversNoItemsOnAny2xxHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])
		let samples = [200, 220, 260, 299]

		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [])
		}
	}

	func test_map_deliversItemsOnAny2xxHTTPResponseWithJSONItems() throws {
		let imageComment1 = makeImageComment(id: UUID(), message: "a message", createdAtString: "2020-05-20T11:24:59+0000", userName: "a user")
		let imageComment2 = makeImageComment(id: UUID(), message: "another message", createdAtString: "2020-05-20T11:24:59+0000", userName: "another user")

		let json = makeItemsJSON([imageComment1.json, imageComment2.json])

		let samples = [200, 220, 260, 299]

		try samples.forEach { code in
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: 200))

			XCTAssertEqual(result, [imageComment1.model, imageComment2.model])
		}
	}

	// MARK: - Helpers

	private func makeImageComment(id: UUID, message: String, createdAtString: String, userName: String) -> (model: ImageComment, json: [String: Any]) {
		let formatter = ISO8601DateFormatter()
		let comment = ImageComment(id: id, message: message, createdAt: formatter.date(from: createdAtString)!, userName: userName)

		let json = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAtString,
			"author": ["username": userName]
		].compactMapValues { $0 }

		return (comment, json)
	}
}
