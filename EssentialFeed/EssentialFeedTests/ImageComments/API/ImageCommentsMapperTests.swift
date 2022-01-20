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
				try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code)), "status code is \(code)"
			)
		}
	}

	func test_map_throwsErrorOnAny2xxHTTPResponseWithInvalidJSON() throws {
		let invalidJSON = Data("invalid json".utf8)

		try validSamples.forEach { code in
			XCTAssertThrowsError(
				try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code)), "status code is \(code)"
			)
		}
	}

	func test_map_deliversNoItemsOnAny2xxHTTPResponseWithEmptyJSONList() throws {
		let emptyListJSON = makeItemsJSON([])

		try validSamples.forEach { code in
			let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [], "status code is \(code)")
		}
	}

	func test_map_deliversItemsOnAny2xxHTTPResponseWithJSONItems() throws {
		let imageComment1 = makeImageComment(id: UUID(), message: "a message", createdAt: ("2020-05-20T11:24:59+0000", Date(timeIntervalSince1970: 1589973899)), userName: "a user")

		let imageComment2 = makeImageComment(id: UUID(), message: "another message", createdAt: ("2003-01-17T12:00:34+0000", Date(timeIntervalSince1970: 1042804834)), userName: "another user")

		let json = makeItemsJSON([imageComment1.json, imageComment2.json])

		try validSamples.forEach { code in
			let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))

			XCTAssertEqual(result, [imageComment1.model, imageComment2.model], "status code is \(code)")
		}
	}

	// MARK: - Helpers

	private var validSamples: [Int] { [200, 220, 260, 299] }

	private func makeImageComment(id: UUID, message: String, createdAt: (String, Date), userName: String) -> (model: ImageComment, json: [String: Any]) {
		let comment = ImageComment(id: id, message: message, createdAt: createdAt.1, userName: userName)

		let json = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAt.0,
			"author": ["username": userName]
		].compactMapValues { $0 }

		return (comment, json)
	}
}
