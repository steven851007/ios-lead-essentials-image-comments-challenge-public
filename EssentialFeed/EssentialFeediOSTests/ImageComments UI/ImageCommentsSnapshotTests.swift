//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_feedWithContent() {
		let sut = makeSUT()

		let imageComment = ImageComment(id: UUID(), message: "a message", createdAt: Date(), userName: "a user")
		let cellConrollers = ImageCommentCellController(viewModel: ImageCommentPresenter.map(imageComment))

		let control = CellController(id: UUID(), cellConrollers)

		sut.display([control])

		record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "IMAGE_COMMENTS_WITH_CONTENT_light")
		record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "IMAGE_COMMENTS_WITH_CONTENT_dark")
		record(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_WITH_CONTENT_light_extraExtraExtraLarge")
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
