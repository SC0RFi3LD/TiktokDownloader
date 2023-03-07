//
//  TicktokDetailVM.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation
import Alamofire

class TicktokDetailVM: BaseVM {
    
    var videoUrl = ""
    var detailModel: TicktokDetailModel?
    
    func fetchTicktokDetailsNetworkRequest(completion: @escaping CompletionHandler) {
        let parameters: [String: Any] = [
            "url": videoUrl
        ]
        
        AFManager.shared.request(url: Globels.shared.API_ENDPOINT, method: .get, parameters: parameters, encoding: URLEncoding.default, decodable: TicktokDetailModel.self) { response, error, code in
            guard code == 200 else {
                completion(false, code, "ERORR")
                return
            }
            self.detailModel = response
            completion(true, code, "SUCCESS")
        }
    }
}
