//
//  WebViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 19/01/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var webView: WKWebView?
    private var networkController = NetworkController()
    
    private var registerURLString: String {
        networkController.getRegistrationURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(didPressBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didPressXmarkButton))
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1"
        
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        guard let webView = webView else {
            return
        }
        
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        guard let url = URL(string: registerURLString) else {
            print("Invalid URL!")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    @objc private func didPressBackButton() {
        if webView!.canGoBack {
            webView!.goBack()
            return
        }
        dismiss(animated: true)
    }
    
    @objc private func didPressXmarkButton() {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        NetworkController().generateAccessToken(from: webView.url)
    }
    
}

