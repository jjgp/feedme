import Combine
import Roots

class FeedViewModel: ObservableObject {
    @Published var items: [FeedItem]

    init(createStore _: CreateStore, items: [FeedItem] = []) {
        self.items = items
    }

    enum FeedItem {
        case reddit(FeedRedditViewModel)
    }

    typealias CreateStore = (FeedReducer, FeedEffect) -> Store<FeedState, FeedAction>
}

extension FeedViewModel {
    func fetchItems() {}
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
            return .init(createStore: createStore, items: items)
        }

        static var createStore: CreateStore {
            { _, _ in
                .init(initialState: FeedState(), reducer: feedReducer(state:action:))
            }
        }
    }
#endif
