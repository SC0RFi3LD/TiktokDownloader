//
//  HomeVC.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-18.
//

import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var downloadUrlLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadUrlLbl.text = "Paste Tiktok Link"
    }
    
    // MARK: Functions
    func navigateToDownloadHistory() {
        let vc = DownloadHistoryVC.storyboardInstantiate(in: .Main, identifier: "DownloadHistoryVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToDetail(_ urlString: String) {
        let vc = TicktokDetailVC.storyboardInstantiate(in: .Main, identifier: "TicktokDetailVC")
        vc.vm.videoUrl = urlString
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Actions
    @IBAction func downloadHistoryAction(_ sender: Any) {
        navigateToDownloadHistory()
    }
    
    @IBAction func pasteAction(_ sender: Any) {
        guard
            let pasteString = UIPasteboard.general.string,
            pasteString != "",
            Globels.shared.validLinkCkeck.contains(where: { pasteString.contains($0) } )
        else {
            AlertManager.shared.singleActionMessage(title: "Alert", message: "Please enter valid link", action: "Ok", vc: self)
            return
        }
        downloadUrlLbl.text = pasteString
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let url = URL(string: downloadUrlLbl.text ?? "") else { return }
        navigateToDetail(url.description)
    }
}

