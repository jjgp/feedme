import UIKit


class FeedTableView: UITableView {
    static let reuseIdentifier = "\(FeedTableView.self)Cell"
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .red
        register(UITableViewCell.self, forCellReuseIdentifier: FeedTableView.reuseIdentifier)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dequeueReusableCell(for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: FeedTableView.reuseIdentifier, for: indexPath)
    }
}

extension FeedTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? Self else {
            fatalError()
        }
        let cell = tableView.dequeueReusableCell(for: indexPath)
        cell.textLabel?.text = "foobar"
        return cell
    }
}

extension FeedTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
}

class FeedController: UIViewController {
    lazy var tableView = {
        FeedTableView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
    }
    
    func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            .init(
                item: tableView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1,
                constant: 0
            ),
            .init(
                item: tableView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            ),
        ])
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
}

// MARK: Preview

#if DEBUG
import SwiftUI

struct FeedControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FeedController {
        FeedController()
    }
    
    func updateUIViewController(_ uiViewController: FeedController, context: Context) {}
    
    typealias UIViewControllerType = FeedController
}

struct FeedControllerPreview: PreviewProvider {
    static var previews: some View {
        FeedControllerRepresentable().ignoresSafeArea()
    }
}
#endif
