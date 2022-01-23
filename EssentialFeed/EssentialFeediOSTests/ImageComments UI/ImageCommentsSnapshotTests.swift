//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_imageCommentsWithContent() {
		let sut = makeSUT()

		sut.display(imageCommentsContent())

		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "IMAGE_COMMENTS_WITH_CONTENT_light")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "IMAGE_COMMENTS_WITH_CONTENT_dark")
		assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_WITH_CONTENT_light_extraExtraExtraLarge")
	}

	private func makeSUT() -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! ListViewController
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func imageCommentsContent() -> [CellController] {
		[shortCommentCellController(), longCommentCellController()]
	}

	private func shortCommentCellController() -> CellController {
		let shortImageComment = ImageComment(id: UUID(), message: "Short comment", createdAt: Date(timeIntervalSinceNow: -1200), userName: "This is a very long user name that might not fit into line one")

		let cellController = ImageCommentCellController(viewModel: ImageCommentPresenter.map(shortImageComment))

		return CellController(id: UUID(), cellController)
	}

	private func longCommentCellController() -> CellController {
		let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis aliquet vitae lorem at placerat. Nam sollicitudin diam vel augue tincidunt consectetur. Pellentesque ultricies ligula ut ipsum ultricies fermentum. Pellentesque ut purus sit amet lacus egestas lobortis. Curabitur varius in leo quis laoreet. Sed ac sagittis sapien, viverra interdum enim.."

		let imageComment = ImageComment(id: UUID(), message: message, createdAt: Date(timeIntervalSinceNow: -120), userName: "a user")

		let cellController = ImageCommentCellController(viewModel: ImageCommentPresenter.map(imageComment))

		return CellController(id: UUID(), cellController)
	}
}
