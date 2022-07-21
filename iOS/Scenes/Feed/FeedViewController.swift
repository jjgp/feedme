import UIKit

class FeedViewController: UIViewController {
    lazy var tableView: FeedTableView = {
        let table = FeedTableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(viewModel: FeedViewModel = FeedViewModel()) {
        super.init(nibName: nil, bundle: nil)
        tableView.setViewModel(viewModel)
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
