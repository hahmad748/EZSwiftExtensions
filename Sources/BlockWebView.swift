#if os(iOS)

import UIKit
import WebKit

/// Make sure you use `[weak self] (NSURLRequest) in` if you are using the keyword `self` inside the closure to avoid memory leaks.
open class BlockWebView: WKWebView, WKNavigationDelegate {
    open var didStartLoad: ((URLRequest) -> Void)?
    open var didFinishLoad: ((URLRequest) -> Void)?
    open var didFailLoad: ((URLRequest, Error) -> Void)?
    open var shouldStartLoadingRequest: ((URLRequest) -> Bool)?

    public override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        self.navigationDelegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationDelegate = self
    }

    // MARK: - WKNavigationDelegate methods

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url {
            let request = URLRequest(url: url)
            didStartLoad?(request)
        }
    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            let request = URLRequest(url: url)
            didFinishLoad?(request)
        }
    }

    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let url = webView.url {
            let request = URLRequest(url: url)
            didFailLoad?(request, error)
        }
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let should = shouldStartLoadingRequest {
            if should(navigationAction.request) {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

#endif
