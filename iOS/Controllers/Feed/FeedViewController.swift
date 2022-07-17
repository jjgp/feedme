import UIKit

class FeedViewController: UIViewController {
    lazy var tableView: FeedTableView = {
        let table = FeedTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bind(to: FeedViewModel())
        return table
    }()

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
            FeedViewController()
        }

        func updateUIViewController(_: FeedViewController, context _: Context) {}

        typealias UIViewControllerType = FeedViewController
    }
#endif
