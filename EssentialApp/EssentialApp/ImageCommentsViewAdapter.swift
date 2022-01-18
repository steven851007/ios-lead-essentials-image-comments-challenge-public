//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class ImageCommentsViewAdapter: ResourceView {
	private weak var controller: ListViewController?

	init(controller: ListViewController) {
		self.controller = controller
	}

	func display(_ viewModel: ImageCommentsViewModel) {
		controller?.display(viewModel.imageComments.map { model in
			let view = ImageCommentCellController(viewModel: ImageCommentPresenter.map(model))

			return CellController(id: model, view)
		})
	}
}
