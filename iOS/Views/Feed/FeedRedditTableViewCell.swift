import UIKit

class FeedRedditTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedRedditTableViewCell.self)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabel)
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
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
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
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

// MARK: Preview

#if DEBUG
    import SwiftUI

    struct FeedTableViewCellRepresentable: UIViewRepresentable, PreviewProvider {
        static var previews: some View {
            FeedTableViewCellRepresentable().fixedIntrinsicContentSize()
        }

        func makeUIView(context _: Context) -> UIViewType {
            let cell = FeedRedditTableViewCell()
            cell.titleLabel.text = "\nfoobarfoobar\n"
            cell.backgroundColor = .red
            return IntrinsicContentHeightView(cell)
        }

        func updateUIView(_: UIViewType, context _: Context) {}

        typealias UIViewType = IntrinsicContentHeightView
    }
#endif
