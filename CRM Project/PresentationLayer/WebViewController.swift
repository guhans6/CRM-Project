//
//  WebViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 19/01/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView?
    
    var registerURLString: String = "https://accounts.zoho.in/oauth/v2/auth?scope=ZohoCRM.settings.ALL,ZohoCRM.users.ALL,ZohoCRM.modules.ALL&client_id=1000.CCNCZ0VYDA4LNN6YCJIUBKO7WA8ZED&response_type=code&access_type=offline&redirect_uri=https://www.google.com/"
    var authRequestString = ""
    
    deinit {
        print("Deinit called")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    func configureUI() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1"
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        guard let webView = webView else {
            print("NOOO")
            return
        }
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        //        webView.frame = view.bounds
        //        webView.navigationDelegate = self
        
        guard let url = URL(string: registerURLString) else {
            print("Invalid URL!")
            return
        }
        
        //        DispatchQueue.main.async {
        webView.load(URLRequest(url: url))
        //        }
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didPressDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(didPressBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didPressXmarkButton))
    }
    
    @objc func didPressBackButton() {
        if webView!.canGoBack {
            webView!.goBack()
            return
        }
        dismiss(animated: true)
    }
    
    @objc func didPressXmarkButton() {
        dismiss(animated: true)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString ?? "No Link")
    }
    
}

