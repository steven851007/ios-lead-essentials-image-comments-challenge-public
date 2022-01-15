//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_feedWithContent() {
		let sut = makeSUT()

		let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis aliquet vitae lorem at placerat. Nam sollicitudin diam vel augue tincidunt consectetur. Pellentesque ultricies ligula ut ipsum ultricies fermentum. Pellentesque ut purus sit amet lacus egestas lobortis. Curabitur varius in leo quis laoreet. Sed ac sagittis sapien, viverra interdum enim."
		let imageComment = ImageComment(id: UUID(), message: message, createdAt: Date(), userName: "a user")
		let cellConrollers = ImageCommentCellController(viewModel: ImageCommentPresenter.map(imageComment))

		let control = CellController(id: UUID(), cellConrollers)

		sut.display([control])

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
}

//private extension ListViewController {
//    func display(_ stubs: [ImageComment]) {
//        let cells: [CellController] = stubs.map { stub in
//            let cellController = ImageCommentCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
//            stub.controller = cellController
//            return CellController(id: UUID(), cellController)
//        }
//
//        display(cells)
//    }
//}
