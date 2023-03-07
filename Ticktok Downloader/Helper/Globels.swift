//
//  Globels.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation

class Globels {
    
    static let shared = Globels()
    
    private init() {}
    
    let API_ENDPOINT = "https://www.tikwm.com/api"
    let validLinkCkeck = ["vm.tiktok", "tiktok.com"]
}
