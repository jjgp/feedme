import protocol Combine.ObservableObject
import struct Combine.Published

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
    extension FeedViewModel {
        static func mock() -> FeedViewModel {
            .init(items: [.reddit(.mock())])
        }
    }
#endif
