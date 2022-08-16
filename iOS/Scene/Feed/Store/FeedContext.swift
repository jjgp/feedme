import Foundation

struct FeedContext {
    let http: HTTP
    let mainQueue: DispatchQueue
}

extension FeedContext {
    static func live() -> Self {
        .init(
            http: HTTP(host: URL(string: "https://reddit.com")!),
            mainQueue: .main
        )
    }
}
