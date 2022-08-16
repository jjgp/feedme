import UIKit

class FeedRedditTableViewCell: UITableViewCell {
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstrants()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedRedditTableViewCell {
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

extension FeedRedditTableViewCell {
    func setViewModel(_ viewModel: FeedRedditViewModel) {
        subredditLabel.text = viewModel.subreddit
        titleLabel.text = viewModel.title
    }
}

extension FeedRedditTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
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
            let cell = FeedRedditTableViewCell()
            cell.setViewModel(.mock())
            return IntrinsicContentHeightView(cell)
        }

        func updateUIView(_: UIViewType, context _: Context) {}

        typealias UIViewType = IntrinsicContentHeightView
    }
#endif
