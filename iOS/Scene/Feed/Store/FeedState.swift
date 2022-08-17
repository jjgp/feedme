import Roots

struct FeedState {
    var isFetching = false
    var listings: [RedditModel.Listing] = []
}
