func feedReducer(state: inout FeedState, action: FeedAction) -> FeedState {
    switch action {
    case let .pushListing(listing):
        state.listings.append(listing)
    default:
        break
    }

    return state
}
