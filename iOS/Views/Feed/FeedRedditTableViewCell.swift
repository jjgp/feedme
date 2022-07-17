import UIKit

class FeedRedditTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedRedditTableViewCell.self)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let reuseIdentifier = reuseIdentifier ?? Self.reuseIdentifier
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
            .init(
                item: titleLabel,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leadingMargin,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: titleLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .topMargin,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: titleLabel,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailingMargin,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: titleLabel,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottomMargin,
                multiplier: 1,
                constant: 0
            ),
        ])
    }

    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
}

// MARK: Preview

#if DEBUG
    import SwiftUI

    struct FeedTableViewCellRepresentable: UIViewRepresentable, PreviewProvider {
        static var previews: some View {
            FeedTableViewCellRepresentable()
                .fixedIntrinsicContentSize()
                .ignoresSafeArea()
        }

        func makeUIView(context _: Context) -> UIViewType {
            let cell = FeedRedditTableViewCell()
            cell.titleLabel.text = "foobarfoobar\n\n"
            cell.backgroundColor = .red
            return IntrinsicContentHeightView(cell)
        }

        func updateUIView(_: UIViewType, context _: Context) {}

        typealias UIViewType = IntrinsicContentHeightView
    }
#endif
