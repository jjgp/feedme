import Combine
import UIKit

class FeedViewController: UIViewController {
    private var subscription: AnyCancellable!

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.register(
            FeedRedditTableViewCell.self,
            forCellReuseIdentifier: .reuseIdentifierForRedditCell
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var viewModel: FeedViewModel!

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        subscription = viewModel.objectWillChange.sink { [weak self] _ in
            // TODO: this isn't correct
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        viewModel.fetchItems()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.viewModel.fetchItems()
        }
    }
}

extension FeedViewController {
    func addConstraints() {
        view.addConstraints([
            tableView.constrain(.leading, on: view!),
            tableView.constrain(.top, on: view!),
            tableView.constrain(.trailing, on: view!),
            tableView.constrain(.bottom, on: view!),
        ])
    }

    func addSubviews() {
        view.addSubview(tableView)
    }
}

// MARK: Table View

extension FeedViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.items[indexPath.row] {
        case let .reddit(model):
            let cell: FeedRedditTableViewCell = tableView
                .dequeueReusableCellOfType(withIdentifier: .reuseIdentifierForRedditCell, for: indexPath)
            cell.setViewModel(model)
            return cell
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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

    struct FeedViewControllerRepresentable: PreviewProvider, UIViewControllerRepresentable {
        static var previews: some View {
            FeedViewControllerRepresentable().ignoresSafeArea()
        }

        func makeUIViewController(context _: Context) -> FeedViewController {
            FeedViewController(viewModel: .mock())
        }

        func updateUIViewController(_: FeedViewController, context _: Context) {}

        typealias UIViewControllerType = FeedViewController
    }
#endif
