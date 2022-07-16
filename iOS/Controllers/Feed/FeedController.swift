import UIKit

class FeedController: UIViewController {
    lazy var tableView = FeedTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
    }

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

    struct FeedControllerRepresentable: PreviewProvider, UIViewControllerRepresentable {
        static var previews: some View {
            FeedControllerRepresentable().ignoresSafeArea()
        }

        func makeUIViewController(context _: Context) -> FeedController {
            FeedController()
        }

        func updateUIViewController(_: FeedController, context _: Context) {}

        typealias UIViewControllerType = FeedController
    }
#endif
