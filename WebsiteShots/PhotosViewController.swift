//
//  ViewController.swift
//  CollectionViewBlog
//
//  Created by Erica Millado on 7/3/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import UIKit
import WebKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, WKNavigationDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var webView: WKWebView!
    
    let store = DataStore.sharedInstance
    var siteDidLoad: ((_ url: URL?)->())?
    var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorite sites"
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(PhotosViewController.refresh))
        webView.navigationDelegate = self
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.center = view.center
        progressView.trackTintColor = UIColor.lightGray
        progressView.tintColor = UIColor.blue
        progressView.isHidden = true
        self.view.addSubview(progressView)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        retakeScreenshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    @objc func refresh() {
        store.clear()
        self.collectionView.reloadData()
        retakeScreenshot()
    }
    
    @IBAction func deleteAllAction(_ sender: UIBarButtonItem) {
        store.deleteAll()
        self.collectionView.reloadData()
    }
    
    func retakeScreenshot() {
        loadNext()
    }
    
    private var current = 0
    func loadNext() {
        guard current < store.screenshots.count else {
            current = 0
            return
        }
        let url = self.store.screenshots[current].url
        webView.load(URLRequest(url: url )) // "https://www.google.com"
        self.siteDidLoad = { url in
            self.webView.scrollView.contentOffset = self.store.screenshots[self.current].contentOffest
            DispatchQueue(label: "com.app.loading").async {
                sleep(2)
                let rect = self.store.screenshots[self.current].rect
                DispatchQueue.main.async {
                    if let image = self.webView.snapshot(of: rect) {
                        self.store.screenshots[self.current].image = image
                        self.store.screenshots[self.current].url = url!
                        self.collectionView.reloadData()
                    }
                    self.current += 1
                    self.loadNext()
                }
            }
        }
    }
}

extension PhotosViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        if let image = store.screenshots[indexPath.row].image{
            cell.displayContent(image: image, title: "Site \(indexPath.row + 1)")
        }
        return cell
        
    }
}

extension PhotosViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue(label: "com.app.loading").async {
            sleep(5)
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                self.siteDidLoad?(webView.url)
            }
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = false
        }
        if keyPath == "loading" {
            if !webView.isLoading {
                print("Finished")
            }
        }
    }
}

