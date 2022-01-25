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

		let imageComment = uniqueImageComment(date: Date().addingTimeInterval(-5 * 61))

		let viewModel = ImageCommentPresenter.map(imageComment, currentDate: now, calendar: calendar, locale: locale)

		XCTAssertEqual(viewModel.comment, imageComment.message)
		XCTAssertEqual(viewModel.date, "5 minutes ago")
		XCTAssertEqual(viewModel.author, imageComment.userName)
	}

	private func uniqueImageComment(date: Date) -> ImageComment {
		return ImageComment(id: UUID(), message: "a message", createdAt: date, userName: "a user")
	}
}
