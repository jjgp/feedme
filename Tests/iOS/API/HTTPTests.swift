import Combine

@testable import feedme
import XCTest

class HTTPRequestCreationTests: XCTestCase {
    func testGETRequest() throws {
        let sut = try HTTP(host: "http://reddit.com")
        let getRequest = HTTPRequest<RedditModel.Listing>(method: .get, path: ".json")
        let urlRequest = try sut.urlRequest(for: getRequest)

        XCTAssertEqual(urlRequest.url?.absoluteString, "http://reddit.com/.json")
    }
}

class HTTPRequestPublisherTests: XCTestCase {
    func testGETRequest() throws {}
}
