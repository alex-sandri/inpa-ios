//
//  SPIDSignInWebView.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

import SwiftUI
import WebKit

#if os(iOS)
typealias WebViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias WebViewRepresentable = NSViewRepresentable
#endif

enum SPIDSignInWebViewError: Error {
    case invalidUrl
}

struct SPIDSignInWebView: WebViewRepresentable {
    let url: URL

    let didFinishLoading: () -> Void?

    let didSignIn: (String) async -> Void

    init(
        idp: SPIDIdentityProvider,
        didFinishLoading: @escaping () -> Void = { },
        didSignIn: @escaping (String) async -> Void
    ) throws {
        let urlString = "https://portale.inpa.gov.it/saml/login/alias/default?idp=\(idp.rawValue)"

        guard let url = URL(string: urlString) else {
            throw SPIDSignInWebViewError.invalidUrl
        }

        self.url = url

        self.didFinishLoading = didFinishLoading

        self.didSignIn = didSignIn
    }
    
    func makeView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()

        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        makeView(context: context)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        updateView(webView, context: context)
    }
    #endif

    #if os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        makeView(context: context)
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        updateView(webView, context: context)
    }
    #endif

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: SPIDSignInWebView

        init(parent: SPIDSignInWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
            let cookies = await webView.configuration.websiteDataStore.httpCookieStore.allCookies()

            for cookie in cookies {
                if cookie.name == "access_token" {
                    await parent.didSignIn(cookie.value)

                    return .cancel
                }
            }

            return .allow
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
            parent.didFinishLoading()
        }
    }
}
