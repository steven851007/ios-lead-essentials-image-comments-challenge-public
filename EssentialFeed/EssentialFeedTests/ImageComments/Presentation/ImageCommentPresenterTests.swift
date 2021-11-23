//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentPresenterTests: XCTestCase {
	func test_map_createsViewModel() {
		let imageComment = uniqueImageComment().comment

		let viewModel = ImageCommentPresenter.map(imageComment)

		XCTAssertEqual(viewModel.comment, imageComment.message)
		XCTAssertEqual(viewModel.date, uniqueImageComment().relativeDate)
		XCTAssertEqual(viewModel.author, imageComment.userName)
	}

	private func uniqueImageComment() -> (comment: ImageComment, relativeDate: String) {
		let date = Date(timeIntervalSinceReferenceDate: 0)
		return (ImageComment(id: UUID(), message: "a message", createdAt: date, userName: "a user"), RelativeDateTimeFormatter().string(for: date)!)
	}
}
