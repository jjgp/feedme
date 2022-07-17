import struct Combine.Published

class FeedViewModel {
    @Published var items: [FeedItem]

    init(items: [FeedItem] = []) {
        self.items = items
    }

    enum FeedItem {
        case reddit(RedditListingViewModel)
    }
}

extension FeedViewModel {
    func fetchItems() {
        let model = RedditListingViewModel()
        model.subreddit = "r/todayilearned"
        model.title = "TIL Michael Jackson wore white tape on his fingers so that audience members further away" +
            "could see the fingers and follow the moves he made with his hands while dancing. He wore white" +
            "socks so they could similarly follow his feet."
        items = [.reddit(model)]
    }
}
