import Roots

enum FeedAction: Action {
    case fetchListing
    case pushListing(RedditModel.Listing)
}
