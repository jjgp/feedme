import Combine
import Foundation
import Roots

typealias FeedEffect = Effect<FeedState, FeedAction>
typealias FeedContextEffect = ContextEffect<FeedState, FeedAction, FeedContext>

extension ContextEffect where S == FeedState, A == FeedAction, Context == FeedContext {
    static func fetchListing() -> Self {
        .publisher { transitionPublisher, context in
            transitionPublisher
                .compactMap { transition -> HTTPRequest<RedditModel.Listing>? in
                    if case .fetchListing = transition.action {
                        return RedditRequest.listing()
                    } else {
                        return nil
                    }
                }
                .map { request in
                    context.http.requestPublisher(for: request)
                }
                .switchToLatest()
                .map { listing in
                    FeedAction.pushListing(listing)
                }
                .catch { _ in
                    Just(FeedAction.fetchListingErrored)
                }
                .receive(on: context.mainQueue)
                .eraseToAnyPublisher()
        }
    }
}
