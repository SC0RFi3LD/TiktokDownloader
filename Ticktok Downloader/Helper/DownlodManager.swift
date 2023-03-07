//
//  DownlodManager.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-18.
//

import UIKit
import Photos
import Alamofire

protocol DownlodManagerDelegate {
    
    func downloadProgress(_ progress: Progress)
}

class DownlodManager {
    
    static let manager = DownlodManager()
    
    var delegate: DownlodManagerDelegate?
    let destination: DownloadRequest.Destination = { _, response in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename ?? "file")
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    init() {}
    
    func download(url: URL, completion: @escaping (_ downloadedFilePath: URL?) -> ()) {
        AF.download(
            url,
            method: .get,
            parameters: [:],
            encoding: URLEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { [weak self] (progress) in
                guard let _ = self else {
                    completion(nil)
                    return
                }
                self?.delegate?.downloadProgress(progress)
            }).response(completionHandler: { (response) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                if let error = response.error {
                    // handle the download error here
                    print("Download Error: \(error.localizedDescription)")
                } else if let fileUrl = response.fileURL {
                    // handle the successful download here
                    print("File downloaded to: \(fileUrl.path)")
                    completion(fileUrl)
                }
            })
    }
}
