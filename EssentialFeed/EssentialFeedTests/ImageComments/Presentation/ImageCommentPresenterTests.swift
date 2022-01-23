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

		let imageComment = uniqueImageComment(date: Date(timeIntervalSinceReferenceDate: 0))
		let mockFormatter = MockRelativeDateTimeFormatter(returnText: "21 years ago")

		let viewModel = ImageCommentPresenter.map(imageComment, currentDate: now, calendar: calendar, locale: locale)

		XCTAssertEqual(viewModel.comment, imageComment.message)
		XCTAssertEqual(viewModel.date, mockFormatter.returnText)
		XCTAssertEqual(viewModel.author, imageComment.userName)
	}

	private func uniqueImageComment(date: Date) -> ImageComment {
		return ImageComment(id: UUID(), message: "a message", createdAt: date, userName: "a user")
	}

	private class MockRelativeDateTimeFormatter: RelativeDateTimeFormatter {
		var returnText: String?

		init(returnText: String) {
			self.returnText = returnText
			super.init()
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}

		override func string(for obj: Any?) -> String? {
			return returnText
		}
	}
}
