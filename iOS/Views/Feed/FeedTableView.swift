import UIKit

class FeedTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        register(RedditListingTableViewCell.self, forCellReuseIdentifier: RedditListingTableViewCell.reuseIdentifier)

        dataSource = self
        delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dequeueReusableCell(for indexPath: IndexPath) -> RedditListingTableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: RedditListingTableViewCell.reuseIdentifier, for: indexPath) as? RedditListingTableViewCell else {
            fatalError()
        }
        return cell
    }
}

extension FeedTableView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? Self else {
            fatalError("tableView is not a \(FeedTableView.self)")
        }

        let model = RedditListingViewModel()
        let cell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(to: model)
        return cell
    }
}

extension FeedTableView: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Preview

#if DEBUG
    import SwiftUI

    struct FeedTableViewRepresentable: UIViewRepresentable, PreviewProvider {
        static var previews: some View {
            FeedTableViewRepresentable().ignoresSafeArea()
        }

        func makeUIView(context _: Context) -> FeedTableView {
            FeedTableView()
        }

        func updateUIView(_: FeedTableView, context _: Context) {}

        typealias UIViewType = FeedTableView
    }
#endif
