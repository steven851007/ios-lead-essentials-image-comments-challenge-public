//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentPresenter {
	public static func map(_ imageComment: ImageComment, formatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()) -> ImageCommentViewModel {
		let dateString = formatter.string(for: imageComment.createdAt)!
		return ImageCommentViewModel(comment: imageComment.message, date: dateString, author: imageComment.userName)
	}
}
