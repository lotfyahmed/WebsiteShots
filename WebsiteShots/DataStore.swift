//
//  DataStore.swift
//  CollectionViewBlog
//
//  Created by Erica Millado on 7/3/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import Foundation
import UIKit

final class DataStore {
    
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    //var audiobooks: [Audiobook] = []
    var images: [UIImage] = []
    
    func add(image: UIImage) {
        images.append(image)
    }
    
    func removeImage(index: Int) {
       images.remove(at: index)
    }
}
