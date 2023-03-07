//
//  Enums.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import UIKit

enum Storyboard: String {
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
