//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentPresenterTests: XCTestCase {
	func test_map_createsViewModel() {
		let now = Date()
		let calendar = Calendar(identifier: .gregorian)
		let locale = Locale(identifier: "en_US_POSIX")

		let viewModels = [
			uniqueImageComment(date: Date().addingTimeInterval(-5 * 61)),
			uniqueImageComment("another message", date: Date().addingTimeInterval(-10 * 61), userName: "another user")
		].map { ImageCommentPresenter.map($0, currentDate: now, calendar: calendar, locale: locale) }

		XCTAssertEqual(viewModels.first?.comment, "a message")
		XCTAssertEqual(viewModels.first?.date, "5 minutes ago")
		XCTAssertEqual(viewModels.first?.author, "a user")

		XCTAssertEqual(viewModels.last?.comment, "another message")
		XCTAssertEqual(viewModels.last?.date, "10 minutes ago")
		XCTAssertEqual(viewModels.last?.author, "another user")
	}

	private func uniqueImageComment(_ message: String = "a message", date: Date, userName: String = "a user") -> ImageComment {
		return ImageComment(id: UUID(), message: message, createdAt: date, userName: userName)
	}
}
