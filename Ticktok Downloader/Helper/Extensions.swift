//
//  Extensions.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import UIKit

extension UIViewController {
    
    static func storyboardInstantiate(in appStoryboard: Storyboard, identifier: String) -> Self {
        return appStoryboard.instance.instantiateViewController(withIdentifier: identifier) as! Self
    }
}

extension FileManager {
    
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
