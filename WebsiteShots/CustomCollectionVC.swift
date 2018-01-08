//
//  CustomCollectionVC.swift
//  PinterestLayout
//
//  Created by Roman Sorochak on 7/7/17.
//  Copyright © 2017 MagicLab. All rights reserved.
//

import UIKit

class CustomCollectionVC: UICollectionViewController {
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


//MARK: UICollectionViewDataSource

extension CustomCollectionVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CollectionCell",
            for: indexPath) as! CollectionViewCell
        
        let image = images[indexPath.item]
        
        cell.imageView.image = image
        
        return cell
    }
}


//MARK: PinterestLayoutDelegate

extension CustomCollectionVC {
    
}

