import Combine
import Roots

class FeedViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var items: [FeedItem]
    private let store: Store<FeedState, FeedAction>

    init(items: [FeedItem] = [], store: Store<FeedState, FeedAction>) {
        self.items = items
        self.store = store

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
}

extension FeedViewModel {
    func fetchItems() {
        store.send(.fetchListing)
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
            return .init(items: items, store: .init(initialState: FeedState(), reducer: feedReducer(state:action:)))
        }
    }
#endif
