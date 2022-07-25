import Roots

enum FeedAction {
    case fetchListing
    case fetchListingErrored
    case pushListing(RedditModel.Listing)
}
