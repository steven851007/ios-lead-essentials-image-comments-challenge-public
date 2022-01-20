//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentEndpointTests: XCTestCase {
	func test_imageComment_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!
		let imageId = UUID()

		let received = ImageCommentEndpoint.get(imageId).url(baseURL: baseURL)
		let expected = URL(string: "http://base-url.com/v1/image/\(imageId.uuidString)/comments")!

		XCTAssertEqual(received, expected)
	}
}
