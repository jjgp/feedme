import Combine
import Foundation
import Roots

typealias FeedEffect = Effect<FeedState, FeedAction>
typealias FeedContextEffect = ContextEffect<FeedState, FeedAction, FeedContext>

extension ContextEffect where State == FeedState, Action == FeedAction, Context == FeedContext {
    static func fetchListing() -> Self {
        .init { states, actions, context in
            states
                .zip(actions)
                .compactMap { state, action -> HTTPRequest<RedditModel.Listing>? in
                    if case .fetchListing = action {
                        let after = state.listings.last?.after
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
