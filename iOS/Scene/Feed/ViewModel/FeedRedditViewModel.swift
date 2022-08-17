struct FeedRedditViewModel {
    let subreddit: String
    let title: String
}

extension RedditModel.Child {
    func toFeedRedditViewModel() -> FeedRedditViewModel {
        .init(subreddit: subredditNamePrefixed, title: title)
    }
}

#if DEBUG
    extension FeedRedditViewModel {
        static func mock() -> Self {
            .init(
                subreddit: "r/todayilearned",
                title: "TIL Michael Jackson wore white tape on his fingers so that audience members further away" +
                    "could see the fingers and follow the moves he made with his hands while dancing. He wore white" +
                    "socks so they could similarly follow his feet."
            )
        }
    }
#endif
