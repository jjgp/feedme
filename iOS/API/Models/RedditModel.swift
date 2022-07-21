enum RedditModel {
    struct Child {
        let id: String
        let subreddit: String
        let subredditNamePrefixed: String
        let title: String
        let thumbnail: String
        let url: String
    }

    enum ChildKeys: String, CodingKey {
        case id
        case subreddit
        case subredditNamePrefixed = "subreddit_name_prefixed"
        case title
        case thumbnail
        case url
    }

    enum DataKey: String, CodingKey {
        case data
    }

    struct Listing {
        let after: String?
        let before: String?
        let children: [Child]
    }

    enum ListingKeys: String, CodingKey {
        case after, before, children
    }
}

extension RedditModel.Listing: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder
            .container(keyedBy: RedditModel.DataKey.self)
            .nestedContainer(keyedBy: RedditModel.ListingKeys.self, forKey: .data)

        after = try container.decodeIfPresent(String.self, forKey: .after)
        before = try container.decodeIfPresent(String.self, forKey: .before)
        children = try container.decode([RedditModel.Child].self, forKey: .children)
    }
}

extension RedditModel.Child: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder
            .container(keyedBy: RedditModel.DataKey.self)
            .nestedContainer(keyedBy: RedditModel.ChildKeys.self, forKey: .data)

        id = try container.decode(String.self, forKey: .id)
        subreddit = try container.decode(String.self, forKey: .subreddit)
        subredditNamePrefixed = try container.decode(String.self, forKey: .subredditNamePrefixed)
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        url = try container.decode(String.self, forKey: .url)
    }
}
