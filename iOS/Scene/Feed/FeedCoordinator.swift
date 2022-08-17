import Roots
import UIKit

class FeedCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let store = Store(
            initialState: FeedState(),
            reducer: feedReducer(state:action:),
            middleware: ApplyEffects(
                context: FeedContext.live(),
                and: FeedEffects.fetchListing()
            )
        )
        let viewModel = FeedViewModel(store: store)

        window.rootViewController = FeedViewController(viewModel: viewModel)
        window.makeKeyAndVisible()
    }
}
