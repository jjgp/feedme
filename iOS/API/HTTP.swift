import Combine
import Foundation

// MARK: Request

struct HTTPRequest<Response: Decodable> {
    let body: Data?
    let method: Method
    let path: String
    let queryParams: [String: String]?

    init(
        body: Data? = nil,
        method: Method,
        path: String,
        queryParams: [String: String]? = nil
    ) {
        self.body = body
        self.method = method
        self.path = path
        self.queryParams = queryParams
    }

    enum Method: String {
        case delete, get, patch, post, put
    }
}

// MARK: HTTP

struct HTTP {
    let host: URL
    let session: URLSession

    init(host: URL, session: URLSession = .shared) {
        self.host = host
        self.session = session
    }

    init(host: String, session: URLSession = .shared) throws {
        guard let host = URL(string: host) else {
            throw URLError(.badURL)
        }

        self.init(host: host, session: session)
    }
}

extension HTTP {
    func urlRequest<T>(for request: HTTPRequest<T>) throws -> URLRequest {
        var components = URLComponents()
        components.path = request.path
        components.queryItems = request.queryParams?.map {
            URLQueryItem(name: $0, value: $1)
        }

        guard let url = components.url(relativeTo: host) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = request.body
        urlRequest.httpMethod = request.method.rawValue.capitalized
        return urlRequest
    }
}

extension HTTP {
    func requestPublisher<T>(for request: HTTPRequest<T>) -> AnyPublisher<T, Error> {
        let urlRequest: URLRequest
        do {
            urlRequest = try self.urlRequest(for: request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      200 ..< 400 ~= httpResponse.statusCode
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder()) // The decoder could be extracted out
            .eraseToAnyPublisher()
    }
}
