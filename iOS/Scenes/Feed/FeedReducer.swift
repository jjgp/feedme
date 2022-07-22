typealias FeedReducer = (inout FeedState, FeedAction) -> FeedState

func feedReducer(state: inout FeedState, action _: FeedAction) -> FeedState {
    state
}
