import Combine
import Foundation
import Roots

typealias FeedEffect = Effect<FeedState, FeedAction>
typealias FeedContextEffect = ContextEffect<FeedState, FeedAction, FeedContext>

extension ContextEffect where S == FeedState, Action == FeedAction, Context == FeedContext {
    static func fetchListing() -> Self {
        .publisher { transitionPublisher, context in
            transitionPublisher
                .compactMap { transition -> HTTPRequest<RedditModel.Listing>? in
                    if case .fetchListing = transition.action {
                        let after = transition.state.listings.last?.after
                        return RedditRequest.listing(after: after)
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
