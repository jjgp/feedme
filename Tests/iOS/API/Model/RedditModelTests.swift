@testable import feedme
import XCTest

class RedditModelTests: XCTestCase {
    func testRedditModelDecoding() throws {
        let listing = try JSONDecoder().decode(RedditModel.Listing.self, from: exampleJSONData)

        XCTAssertEqual(listing.after, "t3_w15wt5")
        XCTAssertNil(listing.before)
        XCTAssertEqual(listing.children.count, 1)

        let child = listing.children.first

        XCTAssertEqual(child?.id, "w180k2")
        XCTAssertEqual(child?.subreddit, "nextfuckinglevel")
        XCTAssertEqual(child?.subredditNamePrefixed, "r/nextfuckinglevel")
        XCTAssertEqual(child?.title, "Dog sets frisbee record for longest catch (109 yards)")
        XCTAssertEqual(
            child?.thumbnail,
            URL(string: "https://b.thumbs.redditmedia.com/eCrl5vMseP4m9Nf4kqD6NxHLY8VB8m_pbExX9u0DZvU.jpg")
        )
        XCTAssertEqual(child?.url, URL(string: "https://v.redd.it/0e73lj2ow4c91"))
    }
}

extension RedditModelTests {
    var exampleJSONData: Data! {
        let json = """
        {
          "data": {
            "after": "t3_w15wt5",
            "children": [
              {
                "data": {
                  "subreddit": "nextfuckinglevel",
                  "title": "Dog sets frisbee record for longest catch (109 yards)",
                  "subreddit_name_prefixed": "r/nextfuckinglevel",
                  "thumbnail_height": 114,
                  "thumbnail_width": 140,
                  "thumbnail": "https://b.thumbs.redditmedia.com/eCrl5vMseP4m9Nf4kqD6NxHLY8VB8m_pbExX9u0DZvU.jpg",
                  "id": "w180k2",
                  "url_overridden_by_dest": "https://v.redd.it/0e73lj2ow4c91",
                  "url": "https://v.redd.it/0e73lj2ow4c91",
                }
              }
            ],
            "before": null
          }
        }
        """
        return json.data(using: .utf8)
    }
}
