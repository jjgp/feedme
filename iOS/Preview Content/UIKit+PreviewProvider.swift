import SwiftUI

extension UIViewRepresentable where UIViewType: IntrinsicContentHeightView {
    func fixedIntrinsicContentSize() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
}

extension UIViewRepresentable where UIViewType: IntrinsicContentWidthView {
    func fixedIntrinsicContentSize() -> some View {
        fixedSize(horizontal: true, vertical: false)
    }
}
