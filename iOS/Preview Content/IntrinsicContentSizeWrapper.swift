import UIKit

// TODO: https://stackoverflow.com/a/67830370

class IntrinsicContentSizeWrapper: UIView {
    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }

            wrappedView.frame = bounds
            wrappedView.layoutIfNeeded()

            systemLayoutSize = wrappedView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        }
    }

    override var intrinsicContentSize: CGSize {
        fatalError("intrinsicContentSize must be implemented in subclass")
    }

    var systemLayoutSize: CGSize = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    var targetSize: CGSize {
        fatalError("targetSize must be implemented in subclass")
    }

    var wrappedView: UIView

    init(_ wrappedView: UIView) {
        self.wrappedView = wrappedView
        super.init(frame: .zero)
        addSubview(wrappedView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IntrinsicContentHeightView: IntrinsicContentSizeWrapper {
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: systemLayoutSize.height)
    }

    override var targetSize: CGSize {
        CGSize(width: frame.width, height: UIView.layoutFittingCompressedSize.height)
    }
}

class IntrinsicContentWidthView: IntrinsicContentSizeWrapper {
    override var intrinsicContentSize: CGSize {
        .init(width: systemLayoutSize.width, height: UIView.noIntrinsicMetric)
    }

    override var targetSize: CGSize {
        CGSize(width: UIView.layoutFittingCompressedSize.width, height: frame.height)
    }
}
