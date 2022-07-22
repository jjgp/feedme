enum RedditRequest {
    static func listing(subreddit: String = "", after: String? = nil) -> HTTPRequest<RedditModel.Listing> {
        var queryParams = ["count": "25"]
        if let after = after {
            queryParams["after"] = after
        }

        return .init(
            method: .get,
            path: "\(subreddit)/.json",
            queryParams: queryParams
        )
    }
}
