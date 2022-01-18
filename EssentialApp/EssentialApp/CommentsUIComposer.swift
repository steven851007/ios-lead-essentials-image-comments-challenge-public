//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], ImageCommentsViewAdapter>

	public static func commentsUIComposedWith(
		commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
		let commentsController = makeImageCommentsViewController(title: ImageCommentsPresenter.title)

		let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
		commentsController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: ImageCommentsViewAdapter(
				controller: commentsController),
			loadingView: WeakRefVirtualProxy(commentsController),
			errorView: WeakRefVirtualProxy(commentsController),
			mapper: ImageCommentsPresenter.map)

		return commentsController
	}

	private static func makeImageCommentsViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let imageCommentsController = storyboard.instantiateInitialViewController() as! ListViewController
		imageCommentsController.title = title
		return imageCommentsController
	}
}
