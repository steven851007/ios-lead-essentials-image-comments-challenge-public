//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

//public protocol ImageCommentsDataLoaderTask {
//	func cancel()
//}
//
//public protocol ImageCommentsDataLoader {
//	typealias Result = Swift.Result<Data, Error>
//
//	func loadImageCommentsData(from url: URL, completion: @escaping (Result) -> Void) -> ImageCommentsDataLoaderTask
//}

public protocol FeedImageDataLoaderTask {
	func cancel()
}

public protocol FeedImageDataLoader {
	typealias Result = Swift.Result<Data, Error>

	func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
