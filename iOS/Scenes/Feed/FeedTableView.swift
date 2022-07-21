import Combine
import UIKit

class FeedTableView: UITableView {
    private var subscription: AnyCancellable!
    private var viewModel: FeedViewModel!

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(FeedRedditTableViewCell.self, forCellReuseIdentifier: .reuseIdentifierForRedditCell)
        dataSource = self
        delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedTableView {
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            viewModel.fetchItems()
        }
        super.willMove(toSuperview: newSuperview)
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

        switch viewModel.items[indexPath.row] {
        case let .reddit(model):
            let cell: FeedRedditTableViewCell = tableView.dequeueReusableCellOfType(withIdentifier: .reuseIdentifierForRedditCell, for: indexPath)
            cell.setViewModel(model)
            return cell
        }
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
    func setViewModel(_ viewModel: FeedViewModel) {
        self.viewModel = viewModel
        subscription = viewModel.objectWillChange.sink { [weak self] _ in
            self?.reloadData()
        }
    }
}

// MARK: Reuse Identifiers

private extension String {
    static var reuseIdentifierForRedditCell: String {
        String(describing: FeedRedditTableViewCell.self)
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
            view.setViewModel(.mock())
            return view
        }

        func updateUIView(_: FeedTableView, context _: Context) {}

        typealias UIViewType = FeedTableView
    }
#endif
