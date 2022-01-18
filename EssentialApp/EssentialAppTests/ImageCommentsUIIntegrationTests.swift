//
// Copyright © 2022 Essential Developer. All rights reserved.
//

import XCTest
import UIKit
import Combine
import EssentialApp
import EssentialFeed
import EssentialFeediOS

class ImageCommentsUIIntegrationTests: XCTestCase {
	func test_imageComments_hasTitle() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, commentsTitle)
	}

	func test_loadImageCommentsActions_requestFeedFromLoader() {
		let (sut, loader) = makeSUT()
		XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view is loaded")

		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view is loaded")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 2, "Expected another loading request once user initiates a reload")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 3, "Expected yet another loading request once user initiates another reload")
	}

	func test_loadingImageCommentsIndicator_isVisibleWhileLoadingFeed() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

		loader.completeImageCommentsLoading(at: 0)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

		sut.simulateUserInitiatedReload()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

		loader.completeImageCommentsLoading(at: 1)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
	}

	private func makeSUT(
		selection: @escaping (FeedImage) -> Void = { _ in },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (ListViewController, LoaderSpy) {
		let loader = LoaderSpy()
		let sut = CommentsUIComposer.commentsUIComposedWith(commentsLoader: loader.loadPublisher)
		return (sut, loader)
	}
}

class LoaderSpy {
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
}
