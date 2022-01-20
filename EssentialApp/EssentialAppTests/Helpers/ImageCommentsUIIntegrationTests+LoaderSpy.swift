//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed
import EssentialFeediOS
import Combine

extension ImageCommentsUIIntegrationTests {
	final class LoaderSpy {
		private var imageCommentsRequests = [PassthroughSubject<[ImageComment], Error>]()

		var loadCommentsCallCount: Int {
			return imageCommentsRequests.count
		}

		func loadPublisher() -> AnyPublisher<[ImageComment], Error> {
			let publisher = PassthroughSubject<[ImageComment], Error>()
			imageCommentsRequests.append(publisher)
			return publisher.eraseToAnyPublisher()
		}

		func completeImageCommentsLoading(with imageComments: [ImageComment] = [], at index: Int = 0) {
			imageCommentsRequests[index].send(imageComments)
		}

		func completeImageCommentsLoadingWithError(at index: Int = 0) {
			let error = NSError(domain: "an error", code: 0)
			imageCommentsRequests[index].send(completion: .failure(error))
		}
	}
}
