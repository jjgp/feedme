import Foundation
import Roots

typealias FeedEffect = Effect<FeedState, FeedAction>

extension Effect where S == FeedState, A == FeedAction {
//    static func fetchListing() -> Self {
//        .publisher(of: FeedEnvironment()) { transitionPublisher, _ in
//            transitionPublisher
//                .compactMap { transition in
//                    if case .fetchListing = transition.action {
//                        // get before and after from state
//                        return RedditRequest.listing()
//                    } else {
//                        return nil
//                    }
//                }
//                .flatMap { (request: HTTPRequest<RedditModel.Listing>) in
//                    let http = HTTP(host: URL(string: "http://reddit.com")!, session: .shared)
//                        .requestPublisher(for: request!)
//                }
//        }
//    }
}
