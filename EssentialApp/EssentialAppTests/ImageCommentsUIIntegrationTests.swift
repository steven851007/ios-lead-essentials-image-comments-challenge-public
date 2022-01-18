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

	func test_loadImageCommentsCompletion_rendersSuccessfullyLoadedFeed() {
		let imageComment0 = makeImageComment()
		let imageComment1 = makeImageComment(message: "Second Message", createdAt: Date.distantPast, userName: "Another user")
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		assertThat(sut, isRendering: [])

		loader.completeImageCommentsLoading(with: [imageComment0], at: 0)
		assertThat(sut, isRendering: [imageComment0])

		sut.simulateUserInitiatedReload()
		loader.completeImageCommentsLoading(with: [imageComment0, imageComment1], at: 1)
		assertThat(sut, isRendering: [imageComment0, imageComment1])
	}

	func test__rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
		let imageComment0 = makeImageComment()
		let imageComment1 = makeImageComment(message: "Second Message", createdAt: Date.distantPast, userName: "Another user")
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeImageCommentsLoading(with: [imageComment0, imageComment1], at: 0)
		assertThat(sut, isRendering: [imageComment0, imageComment1])

		sut.simulateUserInitiatedReload()
		loader.completeImageCommentsLoading(with: [], at: 1)
		assertThat(sut, isRendering: [])
	}

	func test_loadImageCommentsCompletion_doesNotAlterCurrentRenderingStateOnError() {
		let imageComment0 = makeImageComment()
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeImageCommentsLoading(with: [imageComment0], at: 0)
		assertThat(sut, isRendering: [imageComment0])

		sut.simulateUserInitiatedReload()
		loader.completeImageCommentsLoadingWithError(at: 1)
		assertThat(sut, isRendering: [imageComment0])
	}

	func test_loadImageCommentsCompletion_dispatchesFromBackgroundToMainThread() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()

		let exp = expectation(description: "Wait for background queue")
		DispatchQueue.global().async {
			loader.completeImageCommentsLoading(at: 0)
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
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

	private func makeImageComment(message: String = "Default message", createdAt: Date = Date(), userName: String = "A User") -> ImageComment {
		return ImageComment(id: UUID(), message: message, createdAt: createdAt, userName: userName)
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

	func completeImageCommentsLoadingWithError(at index: Int = 0) {
		let error = NSError(domain: "an error", code: 0)
		imageCommentsRequests[index].send(completion: .failure(error))
	}
}
