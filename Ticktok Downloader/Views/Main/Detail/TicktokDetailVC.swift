//
//  TicktokDetailVC.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import UIKit
import SVProgressHUD
import MobileCoreServices

class TicktokDetailVC: BaseVC {
    
    // MARK: Outlets
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var authorNicknameLbl: UILabel!
    @IBOutlet weak var withoutWatermarkLbl: UILabel!
    @IBOutlet weak var withWatermarkLbl: UILabel!
    
    let vm = TicktokDetailVM()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTicktokDetailsNetworkRequest()
        DownlodManager.manager.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DownlodManager.manager.delegate = nil
    }
    
    // MARK: Functions
    func updateUI() {
        guard let model = vm.detailModel?.data else { return }
        
        authorNameLbl.text = model.author?.nickname
        authorNicknameLbl.text = "@\(model.author?.uniqueID ?? "")"
        titleLbl.text = model.title
        withoutWatermarkLbl.text = "Without Watermark | \(getFileSize(model.size ?? 0))"
        withWatermarkLbl.text = "With Watermark | \(getFileSize(model.wmSize ?? 0))"
        
        if let urlString = model.author?.avatar, let _url = URL(string: urlString) {
            avatarImg.af.setImage(withURL: _url, cacheKey: urlString, placeholderImage: UIImage(named: "avatar_image"))
        } else {
            avatarImg.image = UIImage(named: "avatar_image")
        }
    }
    
    func getFileSize(_ size: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB]
        return formatter.string(fromByteCount: Int64(size))
    }
    
    func showShareSheet(_ fileURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: Network Requests
    func fetchTicktokDetailsNetworkRequest() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
        vm.fetchTicktokDetailsNetworkRequest { [weak self] (status, code, message) in
            SVProgressHUD.dismiss()
            guard let _ = self else { return }
            self?.updateUI()
        }
    }
    
    func downloadNetworkRequest(_ downloadURL: URL) {
        DownlodManager.manager.download(url: downloadURL) { [weak self] downloadedFilePath in
            guard let _ = self else { return }
            guard let filePath = downloadedFilePath else { return }
            self?.showShareSheet(filePath)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadWithoutWaterMarkAction(_ sender: Any) {
        guard let _urlString = vm.detailModel?.data?.play, let _url = URL(string: _urlString) else { return }
        downloadNetworkRequest(_url)
    }
    
    @IBAction func downloadWithWaterMarkAction(_ sender: Any) {
        guard let _urlString = vm.detailModel?.data?.wmplay, let _url = URL(string: _urlString) else { return }
        downloadNetworkRequest(_url)
    }
        
}

extension TicktokDetailVC: DownlodManagerDelegate {
    
    func downloadProgress(_ progress: Progress) {
        SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Downloading...")
        print("Download Progress: \(progress.fractionCompleted)")
        if progress.fractionCompleted == 1.0 {
            SVProgressHUD.dismiss()
        }
    }
}
