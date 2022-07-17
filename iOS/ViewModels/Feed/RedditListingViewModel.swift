import struct Combine.Published

class RedditListingViewModel {
    @Published var subreddit: String
    @Published var title: String

    init(subreddit: String = "", title: String = "") {
        self.subreddit = subreddit
        self.title = title
    }
}
