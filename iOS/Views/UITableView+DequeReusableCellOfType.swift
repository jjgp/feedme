import UIKit

extension UITableView {
    func dequeueReusableCellOfType<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell of type \(T.self) for identifier \(identifier)")
        }
        return cell
    }
}
