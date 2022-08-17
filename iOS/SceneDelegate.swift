import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var coordinator: FeedCoordinator!
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        self.window = window
        coordinator = FeedCoordinator(window: window)
        coordinator.start()
    }
}
