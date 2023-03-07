//
//  ErrorModel.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation

struct ErrorModel: Codable {
    var error: String?
    var errorDescription: String?
    
    private enum CodingKeys : String, CodingKey {
        case error = "error"
        case errorDescription = "error_description"
    }
}
