//
//  ViewController.swift
//  WebsiteShots
//
//  Created by AHMED LOTFY on 1/7/18.
//  Copyright © 2018 AHMED LOTFY. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    var rect = CGRect(x: 50, y: 50, width: 300, height: 300)
    let store = DataStore.sharedInstance
    var url = URL(string: "https://apple.com")!
    var canvasView: UIScrollView?
    var selectedView: UIView?
    var firstPoint = CGPoint.zero
    var secondPoint = CGPoint.zero
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var urlField: UITextField!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Site Area"
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PhotosViewController.refresh))
        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        urlField.text = url.path
        urlField.delegate = self
        webView.load(URLRequest(url: url))
        self.webView.navigationDelegate = self
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    @IBAction func addArea(sender: UIBarButtonItem) {
        let title = sender.title
        if  title == "Add Area" {
            addLayer()
            //draw(rect: rect)
            sender.title = "Done"
        } else if title == "Done" {
            removeSelectedView()
            
            let newRect = rectRelatedToZeroOffest()
            if let image = webView.snapshot(of: newRect), let url = webView.url, let screenshot = Screenshot(url:url, image: image, rect: newRect, contentOffest: webView.scrollView.contentOffset) {
                store.add(screenshot: screenshot)
            }
            sender.title = "Add Area"
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func rectRelatedToZeroOffest() -> CGRect {
        let offest = webView.scrollView.contentOffset
        return CGRect(x: rect.origin.x - offest.x, y: rect.origin.y - offest.y, width: rect.width, height: rect.height)
    }
    
    @objc func tapAction(touch: UITapGestureRecognizer) {
        if firstPoint == .zero {
            self.firstPoint = touch.location(in: self.canvasView)
        } else if secondPoint == .zero {
            self.secondPoint = touch.location(in: self.canvasView)
            self.rect = CGRect(x: min(firstPoint.x, secondPoint.x),
                               y:min(firstPoint.y, secondPoint.y),
                               width:fabs(firstPoint.x - secondPoint.x),
                               height:fabs(firstPoint.y - secondPoint.y))
            draw(rect: self.rect)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        if let path = urlField.text, let url = URL(string: path) {
            webView.load(URLRequest(url: url))
        }
        return false
    }
    
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        let request = URLRequest(url:webView.url!)
        webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
}

extension ViewController {
    func addLayer() {
        var frame = webView.scrollView.frame
        frame.size = webView.scrollView.contentSize
        self.canvasView = UIScrollView(frame: frame)
        self.canvasView?.contentOffset = webView.scrollView.contentOffset
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapAction(touch:)) )
        tapGesture.delegate = self
        self.canvasView?.addGestureRecognizer(tapGesture)
        self.webView.addSubview(canvasView!)
    }
    
    func draw(rect: CGRect) {
        self.selectedView = UIView(frame: rect)
        selectedView?.layer.borderWidth = 5
        selectedView?.layer.borderColor = UIColor.green.cgColor
        self.canvasView?.addSubview(selectedView!)
    }
    
    func removeSelectedView() {
        self.canvasView?.removeFromSuperview()
        self.selectedView?.removeFromSuperview()
    }
}

extension ViewController {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
