import UIKit

class FeedRedditTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedRedditTableViewCell.self)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            titleLabel.constrain(.leading, on: contentView, .leadingMargin),
            titleLabel.constrain(.top, on: contentView, .topMargin),
            titleLabel.constrain(.trailing, on: contentView, .trailingMargin),
            titleLabel.constrain(.bottom, on: contentView, .bottomMargin),
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
