//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	public static func commentsUIComposedWith() -> ListViewController {
		let feedController = makeImageCommentsViewController(title: ImageCommentsPresenter.title)
        
		return feedController
	}

	private static func makeImageCommentsViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let imageCommentsController = storyboard.instantiateInitialViewController() as! ListViewController
		imageCommentsController.title = title
		return imageCommentsController
	}
}
