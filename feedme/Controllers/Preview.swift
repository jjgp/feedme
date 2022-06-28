import SwiftUI

struct SwiftUIViewControllerWrapper<T: UIViewController>: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> T {
        T()
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {}
    
}

struct FeedControllerPreview: PreviewProvider {
    
    static var previews: some View {
        SwiftUIViewControllerWrapper<FeedController>().ignoresSafeArea()
    }
    
}

struct FeedControllerPreviewOther: PreviewProvider {
    
    static var previews: some View {
        SwiftUIViewControllerWrapper<FeedController>()
            .ignoresSafeArea()
    }
    
}
