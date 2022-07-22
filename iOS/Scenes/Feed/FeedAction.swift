import Roots

enum FeedAction: Action {
    case fetchListing(after: String? = nil, before: String? = nil)
    case pushListing(RedditModel.Listing)
}
