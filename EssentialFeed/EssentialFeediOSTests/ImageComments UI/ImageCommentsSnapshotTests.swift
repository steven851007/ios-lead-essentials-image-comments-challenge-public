//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_imageCommentsWithContent() {
		let sut = makeSUT()

		sut.display(comments())

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

	private func comments() -> [CellController] {
		return [
			ImageCommentViewModel(
				comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis aliquet vitae lorem at placerat. Nam sollicitudin diam vel augue tincidunt consectetur. Pellentesque ultricies ligula ut ipsum ultricies fermentum. Pellentesque ut purus sit amet lacus egestas lobortis. Curabitur varius in leo quis laoreet. Sed ac sagittis sapien, viverra interdum enim..",
				date: "2 hours ago",
				author: "a user"
			),
			ImageCommentViewModel(
				comment: "Short comment",
				date: "5 minutes ago",
				author: "This is a very long user name that might not fit into line one"
			)
		].map({ CellController(id: UUID(), ImageCommentCellController(viewModel: $0)) })
	}
}
