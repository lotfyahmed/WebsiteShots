//
//  ViewController.swift
//  WebsiteShots
//
//  Created by AHMED LOTFY on 1/7/18.
//  Copyright © 2018 AHMED LOTFY. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var rect = CGRect(x: 50, y: 50, width: 300, height: 300)
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "http://apple.com")! ))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addArea(_ sender: UIButton) {
        if let image = webView.snapshot(of: rect) {
            // do something with `image` here
            store.add(image: image)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of PlayerTableViewController
//        let destinationVC = segue.destination as? PhotosViewController
//        
//        destinationVC?.images.append(selectedImage!)
    }
}
