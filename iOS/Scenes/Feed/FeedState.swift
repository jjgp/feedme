import Roots

struct FeedState: State {
    var isFetching = false
    var listings: [RedditModel.Listing] = []
}
