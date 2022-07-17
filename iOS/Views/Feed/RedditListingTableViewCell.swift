import class Combine.AnyCancellable
import UIKit

class RedditListingTableViewCell: UITableViewCell {
    private var subscriptions: Set<AnyCancellable>!
    static let reuseIdentifier = String(describing: RedditListingTableViewCell.self)

    private lazy var subredditLabel = UILabel()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            subredditLabel,
            titleLabel,
        ])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier ?? Self.reuseIdentifier)
        addSubviews()
        addConstrants()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RedditListingTableViewCell {
    func addConstrants() {
        contentView.addConstraints([
            verticalStack.constrain(.leading, on: contentView, .leadingMargin),
            verticalStack.constrain(.top, on: contentView, .topMargin),
            verticalStack.constrain(.trailing, on: contentView, .trailingMargin),
            verticalStack.constrain(.bottom, on: contentView, .bottomMargin),
        ])
    }

    func addSubviews() {
        contentView.addSubview(verticalStack)
    }
}

extension RedditListingTableViewCell {
    func bind(to viewModel: RedditListingViewModel) {
        prepareLabelsForUse()
        subscriptions = [
            viewModel.$subreddit.assign(to: \.text!, on: subredditLabel),
            viewModel.$title.assign(to: \.text!, on: titleLabel),
        ]
    }
}

extension RedditListingTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.forEach { $0.cancel() }
        prepareLabelsForUse()
    }

    func prepareLabelsForUse() {
        subredditLabel.text = ""
        titleLabel.text = ""
    }
}

// MARK: Preview

#if DEBUG
    import SwiftUI

    struct FeedTableViewCellRepresentable: UIViewRepresentable, PreviewProvider {
        static var previews: some View {
            FeedTableViewCellRepresentable().fixedIntrinsicContentSize()
        }

        func makeUIView(context _: Context) -> UIViewType {
            let model = RedditListingViewModel()
            let cell = RedditListingTableViewCell()
            cell.bind(to: model)
            model.subreddit = "r/todayilearned"
            model.title = "TIL Michael Jackson wore white tape on his fingers so that audience members further away" +
                "could see the fingers and follow the moves he made with his hands while dancing. He wore white" +
                "socks so they could similarly follow his feet."
            return IntrinsicContentHeightView(cell)
        }

        func updateUIView(_: UIViewType, context _: Context) {}

        typealias UIViewType = IntrinsicContentHeightView
    }
#endif
