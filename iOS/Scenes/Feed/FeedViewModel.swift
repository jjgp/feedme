import Combine

class FeedViewModel: ObservableObject {
    @Published var items: [FeedItem]

    init(items: [FeedItem] = []) {
        self.items = items
    }

    enum FeedItem {
        case reddit(FeedRedditViewModel)
    }
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
            return .init(items: items)
        }
    }
#endif
