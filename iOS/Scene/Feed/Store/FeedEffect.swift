import Combine
import Roots

enum FeedEffects {
    static func fetchListing() -> FeedContextEffect {
        ContextEffect { states, actions, context in
            states
                .zip(actions)
                .compactMap { state, action in
                    if case .fetchListing = action {
                        return RedditRequest.listing(after: state.listings.last?.after)
                    } else {
                        return nil
                    }
                }
                .map(context.http.requestPublisher(for:))
                .switchToLatest()
                .map(FeedAction.pushListing)
                .catch { _ in
                    Just(FeedAction.fetchListingErrored)
                }
                .receive(on: context.mainQueue)
        }
    }

    typealias FeedContextEffect = ContextEffect<FeedState, FeedAction, FeedContext>
}
