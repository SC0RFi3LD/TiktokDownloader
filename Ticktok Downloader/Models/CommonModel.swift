//
//  CommonModel.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation

struct CommonModel: Codable {
    var modelState: [String:[String]]?
    var message: String?
    var errorMessage: String?
    var error: String?
    var messageText: String?
    var status: String?
    var isValid: Bool?
    
    private enum CodingKeys : String, CodingKey {
        case modelState = "ModelState"
        case message = "Message"
        case messageText = "message"
    }
}
