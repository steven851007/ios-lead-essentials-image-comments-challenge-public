//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

extension ImageCommentsUIIntegrationTests {
	func assertThat(_ sut: ListViewController, isRendering imageComments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
		sut.view.enforceLayoutCycle()

		guard sut.numberOfRenderedFeedImageViews() == imageComments.count else {
			return XCTFail("Expected \(imageComments.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
		}

		imageComments.enumerated().forEach { index, image in
			assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
		}

		executeRunLoopToCleanUpReferences()
	}

	func assertThat(_ sut: ListViewController, hasViewConfiguredFor imageComment: ImageComment, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
		let view = sut.feedImageView(at: index)

		guard let cell = view as? ImageCommentCell else {
			return XCTFail("Expected \(ImageCommentCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.userName, imageComment.userName, "username at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.dateText, ImageCommentPresenter.map(imageComment).date, "created date at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.comment, imageComment.message, "message at index (\(index))", file: file, line: line)
	}

	private func executeRunLoopToCleanUpReferences() {
		RunLoop.current.run(until: Date())
	}
}
