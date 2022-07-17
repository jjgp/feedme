import UIKit

extension UIView {
    func constrain(
        _ attribute: NSLayoutConstraint.Attribute,
        on item: Any!,
        _ otherAttribute: NSLayoutConstraint.Attribute? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        .init(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: item,
            attribute: otherAttribute ?? attribute,
            multiplier: multiplier,
            constant: constant
        )
    }
}
