//
//  SPIDSignInWebView.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

import SwiftUI
import WebKit

enum SPIDSignInWebViewError: Error {
    case invalidUrl
}

struct SPIDSignInWebView: UIViewRepresentable {
    let url: URL

    let didSignIn: (String) -> Void

    init(idp: SPIDIdentityProvider, didSignIn: @escaping (String) -> Void) throws {
        let urlString = "https://portale.inpa.gov.it/saml/login/alias/default?idp=\(idp.rawValue)"

        guard let url = URL(string: urlString) else {
            throw SPIDSignInWebViewError.invalidUrl
        }

        self.url = url
        self.didSignIn = didSignIn
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()

        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

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
                if (cookie.name == "access_token") {
                    parent.didSignIn(cookie.value)

                    return .cancel
                }
            }

            return .allow
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
        }
    }
}