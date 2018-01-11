//
//  Screenshot.swift
//  WebsiteShots
//
//  Created by AHMED LOTFY on 1/8/18.
//  Copyright © 2018 AHMED LOTFY. All rights reserved.
//

import UIKit
import os.log

class Screenshot: NSObject, NSCoding {
    var url: URL
    var image: UIImage?
    var rect: CGRect = CGRect.zero
    var contentOffest = CGPoint.zero
    
    //MARK: Types
    struct PropertyKey {
        static let url = "url"
        static let image = "image"
        static let rect = "rect"
        static let contentOffest = "contentOffest"
    }
    
    //MARK: Initialization
    init?(url: URL, image: UIImage?, rect: CGRect, contentOffest: CGPoint) {
        // Initialize stored properties.
        self.url = url
        self.image = image
        self.rect = rect
        self.contentOffest = contentOffest
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: PropertyKey.url)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(rect, forKey: PropertyKey.rect)
        aCoder.encode(contentOffest, forKey: PropertyKey.contentOffest)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The url is required. If we cannot decode a url string, the initializer should fail.
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? URL else {
            os_log("Unable to decode the url for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let rectString = aDecoder.decodeObject(forKey: PropertyKey.rect) as? String ?? ""
        let rect = CGRectFromString(rectString)
        let contentOffestString = aDecoder.decodeObject(forKey: PropertyKey.contentOffest) as? String ?? ""
        let contentOffest = CGPointFromString(contentOffestString)
        self.init(url: url, image: image, rect: rect, contentOffest: contentOffest)
        
    }
}


