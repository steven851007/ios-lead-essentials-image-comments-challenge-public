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
		[longCommentCellController(), shortCommentCellController()]
	}

	private func shortCommentCellController() -> CellController {
		let viewModel = ImageCommentViewModel(comment: "Short comment", date: "5 minutes ago", author: "This is a very long user name that might not fit into line one")

		return CellController(id: UUID(), ImageCommentCellController(viewModel: viewModel))
	}

	private func longCommentCellController() -> CellController {
		let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis aliquet vitae lorem at placerat. Nam sollicitudin diam vel augue tincidunt consectetur. Pellentesque ultricies ligula ut ipsum ultricies fermentum. Pellentesque ut purus sit amet lacus egestas lobortis. Curabitur varius in leo quis laoreet. Sed ac sagittis sapien, viverra interdum enim.."

		let viewModel = ImageCommentViewModel(comment: message, date: "2 hours ago", author: "a user")

		return CellController(id: UUID(), ImageCommentCellController(viewModel: viewModel))
	}
}
