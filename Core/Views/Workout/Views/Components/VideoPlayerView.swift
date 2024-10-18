import SwiftUI
import WebKit

struct VideoPlayerView: UIViewRepresentable {
    let videoURL: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: videoURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view
    }
}

