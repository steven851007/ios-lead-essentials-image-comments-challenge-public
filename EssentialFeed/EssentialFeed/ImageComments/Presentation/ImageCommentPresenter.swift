//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentPresenter {
	public static func map(_ imageComment: ImageComment, currentDate: Date = Date(), calendar: Calendar = .current, locale: Locale = .current) -> ImageCommentViewModel {
		let formatter = RelativeDateTimeFormatter()
		formatter.calendar = calendar
		formatter.locale = locale
		let dateString = formatter.localizedString(for: imageComment.createdAt, relativeTo: currentDate)
		return ImageCommentViewModel(comment: imageComment.message, date: dateString, author: imageComment.userName)
	}
}
