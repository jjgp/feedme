import Roots

enum FeedAction: Action {
    case fetchListing
    case fetchListingErrored
    case pushListing(RedditModel.Listing)
}
