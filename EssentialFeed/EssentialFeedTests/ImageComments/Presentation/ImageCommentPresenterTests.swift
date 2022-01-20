//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentPresenterTests: XCTestCase {
	func test_map_createsViewModel() {
		let dateText = "21 years ago"
		let imageComment = uniqueImageComment(date: Date(timeIntervalSinceReferenceDate: 0))

		let viewModel = ImageCommentPresenter.map(imageComment)

		XCTAssertEqual(viewModel.comment, imageComment.message)
		XCTAssertEqual(viewModel.date, dateText)
		XCTAssertEqual(viewModel.author, imageComment.userName)
	}

	private func uniqueImageComment(date: Date) -> ImageComment {
		return ImageComment(id: UUID(), message: "a message", createdAt: date, userName: "a user")
	}
}
