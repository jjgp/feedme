import Combine
import Foundation
import Roots

typealias FeedEffect = Effect<FeedState, FeedAction>

extension Effect where S == FeedState, A == FeedAction {
    static func fetchListing(with environment: FeedEnvironment) -> Self {
        .publisher(of: environment) { transitionPublisher, _ -> AnyPublisher<A, Never> in
            transitionPublisher
                .compactMap { transition -> HTTPRequest<RedditModel.Listing>? in
                    if case .fetchListing = transition.action {
                        return .init(method: .get, path: ".json")
                    } else {
                        return nil
                    }
                }
                .map { request in
                    environment.http.requestPublisher(for: request)
                }
                .switchToLatest()
                .map { listing in
                    FeedAction.pushListing(listing)
                }
                .catch { _ in
                    Just(FeedAction.fetchListingErrored)
                }
                .receive(on: environment.mainQueue)
                .eraseToAnyPublisher()
        }
    }
}
