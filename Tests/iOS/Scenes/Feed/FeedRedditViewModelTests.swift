@testable import feedme
import XCTest

class FeedRedditViewModelTests: XCTestCase {
    func testToRedditModelChildToViewModel() {
        let child = RedditModel.Child(
            id: "id",
            subreddit: "subreddit",
            subredditNamePrefixed: "subredditNamePrefixed",
            title: "title",
            thumbnail: URL(string: "http://thumbnail.com")!,
            url: URL(string: "http://url.com")!
        )
        let model = child.toFeedRedditViewModel()

        XCTAssertEqual(model.subreddit, "subredditNamePrefixed")
        XCTAssertEqual(model.title, "title")
    }
}
