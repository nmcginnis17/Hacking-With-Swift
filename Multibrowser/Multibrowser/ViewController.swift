//
//  ViewController.swift
//  Multibrowser
//
//  Created by Nicholas McGinnis on 1/1/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addressBar: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }

    @objc func addWebView() {
        // Add new WKWebView to UIStackView
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://hackingwithswift.com")!
        webView.load(URLRequest(url: url))
    }
    
    @objc func deleteWebView() {
        
    }

}

