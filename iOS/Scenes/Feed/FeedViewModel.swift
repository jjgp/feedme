import Combine
import Roots

class FeedViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var items: [FeedItem]
    private let store: Store<FeedState, FeedAction>

    init(items: [FeedItem] = [], createStore: CreateStore) {
        self.items = items
        let context = FeedContext(
            http: HTTP(host: URL(string: "https://reddit.com")!),
            mainQueue: .main
        )
        let middleware = ApplyEffects(context: context, and: FeedContextEffect.fetchListing())
        store = createStore(
            feedReducer(state:action:),
            middleware
        )
        store.sink { [weak self] newState in
            self?.items = newState
                .listings
                .flatMap(\.children)
                .map {
                    .reddit($0.toFeedRedditViewModel())
                }
        }
        .store(in: &cancellables)
    }

    enum FeedItem {
        case reddit(FeedRedditViewModel)
    }

    typealias CreateStore = (@escaping FeedReducer, Middleware<FeedState, FeedAction>) -> Store<FeedState, FeedAction>
}

extension FeedViewModel {
    func fetchItems() {
        store.send(.fetchListing)
    }
}

extension FeedViewModel {
    static func live() -> FeedViewModel {
        .init { reducer, middleware in
            Store(initialState: FeedState(), reducer: reducer, middleware: middleware)
        }
    }
}

#if DEBUG
    import UIKit

    extension FeedViewModel {
        static func mock() -> FeedViewModel {
            let asset = NSDataAsset(name: "reddit", bundle: .main)
            let data = asset!.data
            let listing = try? JSONDecoder().decode(RedditModel.Listing.self, from: data)
            let items = listing!.children.map { child -> FeedViewModel.FeedItem in
                .reddit(child.toFeedRedditViewModel())
            }
            return .init(items: items, createStore: mockStore)
        }

        static var mockStore: CreateStore {
            { _, _ in
                .init(initialState: FeedState(), reducer: feedReducer(state:action:))
            }
        }
    }
#endif
