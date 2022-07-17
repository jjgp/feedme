import class Combine.AnyCancellable
import UIKit

class FeedTableView: UITableView {
    private var viewModel: FeedViewModel!
    private var subscription: AnyCancellable!

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
}

extension FeedTableView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? Self else {
            fatalError("tableView is not a \(FeedTableView.self)")
        }

        let cell: UITableViewCell
        switch viewModel.items[indexPath.row] {
        case let .reddit(model):
            guard let redditCell = tableView.dequeueReusableCell(withIdentifier: RedditListingTableViewCell.reuseIdentifier, for: indexPath) as? RedditListingTableViewCell else {
                fatalError("\(RedditListingTableViewCell.reuseIdentifier) has not been registered")
            }
            redditCell.bind(to: model)
            cell = redditCell
        }

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

extension FeedTableView {
    func bind(to viewModel: FeedViewModel) {
        subscription?.cancel()
        self.viewModel = viewModel
        subscription = viewModel.$items.sink { [weak self] _ in
            self?.reloadData()
        }
        // TODO: only fetch when moved to superview
        viewModel.fetchItems()
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
            let view = FeedTableView()
            view.bind(to: FeedViewModel())
            return view
        }

        func updateUIView(_: FeedTableView, context _: Context) {}

        typealias UIViewType = FeedTableView
    }
#endif
