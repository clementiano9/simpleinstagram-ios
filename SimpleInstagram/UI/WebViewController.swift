//
//  WebViewController.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView?
    
    let redirectUrl = "https://www.facebook.com/"
    let clientId = "266981247601315"
    let clientSecret = "32b54b4430b8ad58cb678ec81a0ce3fe"
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true        
        
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.instagram.com/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUrl)&response_type=code&display=touch&scope=user_profile,user_media")
        let myRequest = URLRequest(url: url!)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        DispatchQueue.main.async {
            self.webView.load(myRequest)
        }
        
    }

    func extractAccessCode() {
        print("Extracting code")
        guard let url = webView.url?.absoluteString.removingPercentEncoding else { return }
        if (url.contains("code=")) {
            guard let startIndex = url.range(of: "code=")?.upperBound else {
                print("Couldnt get endIndex")
                return
            }
            guard let endIndex = url.firstIndex(of: "#") else {
                print("Couldnt get endIndex")
                return
                
            }
            
            let accessCode = url[startIndex..<endIndex]
            print("Access code = \(accessCode)")
            
            getLongLivedAccessToken(with: String(accessCode))
        }
    }
    let disposeBag = DisposeBag()
    
    /*
     * Fetches a short lived access token using the access code, then exchanges it with a long lived token
     */
    func getLongLivedAccessToken(with accessCode: String) {
        let authManager = AuthRequestManager()
        authManager.getAccessToken(code: accessCode, clientId: clientId, clientSecret: clientSecret, redirectUrl: redirectUrl)
            .flatMap { (response) -> Observable<AccessTokenResponse> in
                return authManager.getLongLivedToken(accessToken: response.accessToken!, clientSecret: self.clientSecret)
        }.subscribe(onNext: { [weak self] (response) in
            //print("Access token gotten: \(response.accessToken)")
            if let accessToken = response.accessToken {
                UserManager.setLoggedIn(token: accessToken)
                
                self?.launchProfileView()
            } else {
                print("Error fetching access token")
            }
        }, onError: { error in
            print("Error getting access token: \(error)")
        }).disposed(by: disposeBag)
    }
    
    func launchProfileView() {
        let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"profile")
        let window = UIApplication.shared.windows[0] as UIWindow;
        window.rootViewController = next;
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}


extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activityIndicator = UIActivityIndicatorView.init(frame: CGRect(origin: CGPoint(x: view.frame.size.width / 2 - 20, y: 40), size: CGSize(width: 40, height: 40)))
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
        
        guard let url = webView.url?.absoluteString.removingPercentEncoding else {
            return
        }
        if url.contains("code=") {
            self.extractAccessCode()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator?.isHidden = true
        activityIndicator?.stopAnimating()
    }
}
