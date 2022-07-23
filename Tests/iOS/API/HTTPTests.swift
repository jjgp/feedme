import Combine

@testable import feedme
import XCTest

class HTTPRequestCreationTests: XCTestCase {
    func testGETRequest() throws {
        let sut = try HTTP(host: "http://reddit.com")
        let getRequest = HTTPRequest<RedditModel.Listing>(method: .get, path: ".json")
        let urlRequest = try sut.urlRequest(from: getRequest)

        XCTAssertEqual(urlRequest.url?.absoluteString, "http://reddit.com/.json")
    }
}

class HTTPRequestPublisherTests: XCTestCase {
    func testGETRequest() throws {
        let sut = try HTTP(host: "http://reddit.com")
        let getRequest = HTTPRequest<RedditModel.Listing>(method: .get, path: ".json")

        let expect = expectation(description: "Listing is received")
        let expectCompletion = expectation(description: "complete is called")
        let subscription = Just(getRequest)
            .tryMap {
                try sut.urlRequest(from: $0)
            }
            .flatMap {
                sut
                    .session
                    .dataTaskPublisher(for: $0)
                    .tryMap { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                              200 ..< 400 ~= httpResponse.statusCode
                        else {
                            throw URLError(.badServerResponse)
                        }
                        return element.data
                    }
                    .decode(type: RedditModel.Listing.self, decoder: JSONDecoder())
            }
            .sink(receiveCompletion: { error in
                print(error)
                expectCompletion.fulfill()
            }, receiveValue: { model in
                print(model)
                expect.fulfill()
            })

        wait(for: [expect, expectCompletion], timeout: .infinity)
        subscription.cancel()
    }
}
