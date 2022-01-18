//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import CoreData
import Combine
import EssentialFeed

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	private lazy var httpClient: HTTPClient = {
		URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
	}()

	private lazy var store: FeedStore & FeedImageDataStore = {
		try! CoreDataFeedStore(
			storeURL: NSPersistentContainer
				.defaultDirectoryURL()
				.appendingPathComponent("feed-store.sqlite"))
	}()

	private lazy var localFeedLoader: LocalFeedLoader = {
		LocalFeedLoader(store: store, currentDate: Date.init)
	}()

	private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!

	private lazy var navigationController = UINavigationController(
		rootViewController: FeedUIComposer.feedComposedWith(
			feedLoader: makeRemoteFeedLoaderWithLocalFallback,
			imageLoader: makeLocalImageLoaderWithRemoteFallback,
			selection: showComments))

	convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
		self.init()
		self.httpClient = httpClient
		self.store = store
	}

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: scene)
		configureWindow()
	}

	func configureWindow() {
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	func sceneWillResignActive(_ scene: UIScene) {
		localFeedLoader.validateCache { _ in }
	}

	private func showComments(for image: FeedImage) {
		let commentsController = CommentsUIComposer.commentsUIComposedWith { [unowned self] in
			self.makeRemoteCommentsLoader(imageId: image.id)
		}
		navigationController.pushViewController(commentsController, animated: true)
	}

	private func makeRemoteCommentsLoader(imageId: UUID) -> AnyPublisher<[ImageComment], Error> {
		let url = ImageCommentEndpoint.get.url(baseURL: baseURL, imageId: imageId)

		return httpClient
			.getPublisher(url: url)
			.tryMap(ImageCommentsMapper.map)
			.eraseToAnyPublisher()
	}

	private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[FeedImage], Error> {
		let url = FeedEndpoint.get.url(baseURL: baseURL)

		return httpClient
			.getPublisher(url: url)
			.tryMap(FeedItemsMapper.map)
			.caching(to: localFeedLoader)
			.fallback(to: localFeedLoader.loadPublisher)
	}

	private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
		let localImageLoader = LocalFeedImageDataLoader(store: store)

		return localImageLoader
			.loadImageDataPublisher(from: url)
			.fallback(to: { [httpClient] in
				httpClient
					.getPublisher(url: url)
					.tryMap(FeedImageDataMapper.map)
					.caching(to: localImageLoader, using: url)
			})
	}
}
