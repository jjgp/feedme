import UIKit

class FeedViewController: UIViewController {
    lazy var tableView = FeedTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
    }
}

extension FeedViewController {
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            tableView.constrain(.leading, on: view),
            tableView.constrain(.top, on: view),
            tableView.constrain(.trailing, on: view),
            tableView.constrain(.bottom, on: view),
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
            FeedViewController()
        }

        func updateUIViewController(_: FeedViewController, context _: Context) {}

        typealias UIViewControllerType = FeedViewController
    }
#endif
