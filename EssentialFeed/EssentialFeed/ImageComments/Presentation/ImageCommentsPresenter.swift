//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageCommentViewModel {}

public final class ImageCommentsPresenter {
	public static var title: String {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: ImageCommentsPresenter.self),
			comment: "Title for the image comments view")
	}

	public static func map(_ image: ImageComment) -> ImageCommentViewModel {
		ImageCommentViewModel()
	}
}
