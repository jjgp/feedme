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
            .init(
                item: tableView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            ),
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
