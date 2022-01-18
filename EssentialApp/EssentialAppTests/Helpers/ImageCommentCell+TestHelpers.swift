//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeediOS

extension ImageCommentCell {
	var userName: String? {
		authorLabel.text
	}

	var dateText: String? {
		dateLabel.text
	}

	var comment: String? {
		commentLabel.text
	}
}
