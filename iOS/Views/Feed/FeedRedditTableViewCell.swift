import UIKit

class FeedRedditTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FeedRedditTableViewCell.self)
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

        func makeUIView(context _: Context) -> FeedRedditTableViewCell {
            let cell = FeedRedditTableViewCell()
            cell.textLabel?.text = "foobar"
            cell.backgroundColor = .red
            return cell
        }

        func updateUIView(_: FeedRedditTableViewCell, context _: Context) {}

        typealias UIViewType = FeedRedditTableViewCell
    }
#endif
