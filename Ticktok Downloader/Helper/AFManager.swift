//
//  AFManager.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation
import Alamofire

class AFManager {
    
    static let shared: AFManager = {
        let _shared = AFManager()
        return _shared
    }()
    
    private init() {}
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func request<T: Decodable>(url: String, method: HTTPMethod, header: [String: String] = [:], parameters: [String: Any] = [:], encoding: ParameterEncoding = JSONEncoding.default, decodable: T.Type, completion: @escaping (_ response: T?, _ error: Any?, _ code: Int) -> Void) {
        guard isConnectedToInternet() else {
            completion(nil, ErrorModel(error: "Error", errorDescription: NSLocalizedString("NO_INTERNET_CONNECTION", comment: "You are not connected to the internet, please try again!")), 503)
            return
        }
        
        var _header: [HTTPHeader] = header.map({HTTPHeader(name: $0.key, value: $0.value)})
        _header.append(HTTPHeader(name: "Accept", value: "application/json"))
        
        var _parameters = parameters
        
        AF.request(url, method: method, parameters: _parameters, encoding: encoding, headers: HTTPHeaders(_header)).validate()
            .cURLDescription { description in print(description) }
            .responseDecodable(of: decodable.self) { response in
                debugPrint(response)
                completion(response.value, response.data ?? response.error, response.response?.statusCode ?? 500)
            }
            .responseString(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    print("SUCCESS:", value)
                case .failure(let error):
                    print("ERROR:", error)
                }
            })
    }
}
