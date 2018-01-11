//
//  DataStore.swift
//  CollectionViewBlog
//
//  Created by Erica Millado on 7/3/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import Foundation
import os.log

final class DataStore {
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("shots")
    
    static let sharedInstance = DataStore()
    
    fileprivate init() {
        screenshots = loadShots()
    }
    
    var screenshots: [Screenshot] = []
    
    func add(screenshot: Screenshot) {
        screenshots.append(screenshot)
        saveShots()
    }
    
    func removeImage(index: Int) {
       screenshots.remove(at: index)
        saveShots()
    }
    
    func clear() {
        for i in 0..<screenshots.count {
            screenshots[i].image = nil
        }
        //saveShots()
    }
    
    func deleteAll() {
        let exists = FileManager.default.fileExists(atPath: DataStore.ArchiveURL.path)
        if exists {
            do {
                try FileManager.default.removeItem(at: DataStore.ArchiveURL)
                screenshots = []
            }catch _ as NSError {
                os_log("Failed to delete shots...", log: OSLog.default, type: .error)
            }
        }
    }
    
    private func saveShots() {
        //self.clear()
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(screenshots, toFile: DataStore.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Shots successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save shots...", log: OSLog.default, type: .error)
        }
    }
    
    func loadShots() -> [Screenshot]  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DataStore.ArchiveURL.path) as? [Screenshot] ?? []
    }

    
}
