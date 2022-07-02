import UIKit

class FeedTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedTableViewCell.self)
}

class FeedTableView: UITableView {
    let reuseIdentifier = "\(FeedTableView.self)Cell"

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.reuseIdentifier)

        dataSource = self
        delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dequeueReusableCell(for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
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

        let cell = tableView.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = "foobar"
        return cell
    }
}

extension FeedTableView: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        45
    }
}

// MARK: Preview

#if DEBUG
    import SwiftUI

    struct FeedTableViewCellRepresentable: UIViewRepresentable, PreviewProvider {
        static var previews: some View {
            FeedTableViewCellRepresentable()
                .ignoresSafeArea()
                .frame(idealHeight: 45)
                .fixedSize(horizontal: false, vertical: true)
        }

        func makeUIView(context _: Context) -> FeedTableViewCell {
            let cell = FeedTableViewCell()
            cell.textLabel?.text = "foobar"
            cell.backgroundColor = .red
            return cell
        }

        func updateUIView(_: FeedTableViewCell, context _: Context) {}

        typealias UIViewType = FeedTableViewCell
    }

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
