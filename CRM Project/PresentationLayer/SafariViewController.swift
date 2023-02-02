//
//  ViewController.swift
//  CRM Project
//
//  Created by guhan-pt6208 on 26/01/23.
//

import UIKit
import SafariServices

class SafariViewController: UIViewController {

    private let registerURLString: String = "https://accounts.zoho.in/oauth/v2/auth?scope=ZohoCRM.settings.ALL,ZohoCRM.users.ALL,ZohoCRM.modules.ALL&client_id=1000.CCNCZ0VYDA4LNN6YCJIUBKO7WA8ZED&response_type=code&access_type=offline&redirect_uri=https://guhans6.github.io/logIn-20611/"
    
//    var safariVc: SFSafariViewController!
    
    deinit {
        print("Deinits called")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    func configureUI() {
        DispatchQueue.main.async {
            let safariVc = SFSafariViewController(url: URL(string: self.registerURLString)!)
            safariVc.delegate = self
            self.present(safariVc, animated: false)
        }
    }
    
}

extension SafariViewController: SFSafariViewControllerDelegate {

    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("works?")
        do {
            try NetworkController().getAccessToken(from: URL)
        } catch {
            print(error)
        }
    }
}
