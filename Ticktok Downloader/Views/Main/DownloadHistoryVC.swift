//
//  DownloadHistoryVC.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-26.
//

import UIKit
import AVKit
import AVFoundation
import SVProgressHUD

class DownloadHistoryVC: UIViewController {
    
    @IBOutlet weak var fileHistoryTable: UITableView!
    @IBOutlet weak var emptyPlaceholderView: UIStackView!
    
    var fileURLs: [URL] = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDownloaedFiles()
    }
    
    // MARK: Functions
    func fetchDownloaedFiles() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            self.fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            emptyPlaceholderView.isHidden = self.fileURLs.isEmpty == false
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func showActionSheet(_ fileURL: URL, at indexPath: IndexPath) {
        let sheet = UIAlertController(title: "Please select an option", message: "", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Play", style: .default) { _ in
            self.playVideo(fileURL)
        })
        sheet.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.showShareSheet(fileURL)
        })
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteFile(fileURL, at: indexPath)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(sheet, animated: true)
    }
    
    func showShareSheet(_ fileURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    func playVideo(_ fileURL: URL) {
        let player = AVPlayer(url: fileURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    func deleteFile(_ fileURL: URL, at indexPath: IndexPath? = nil) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("DELETED", fileURL.lastPathComponent)
            
            guard let _indexPath = indexPath else { return }
            fileHistoryTable.beginUpdates()
            fileURLs.remove(at: _indexPath.row)
            fileHistoryTable.deleteRows(at: [_indexPath], with: .fade)
            fileHistoryTable.endUpdates()
        } catch {
            print(error)
        }
    }

    // MARK: Actions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        AlertManager.shared.multipleActionMessage(title: "Clear History", message: "Do you want to clear all download history?", actions: ["Yes", "No"], vc: self) { [weak self] (action) in
            guard let _ = self else { return }
            if action == "Yes" {
                SVProgressHUD.show()
                for fileURL in self?.fileURLs ?? [] {
                    DispatchQueue.main.async {
                        self?.deleteFile(fileURL)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SVProgressHUD.dismiss()
                    self?.fetchDownloaedFiles()
                    self?.fileHistoryTable.reloadData()
                }
            }
        }
    }
}

// MARK: Table Delegate
extension DownloadHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadedFileCell", for: indexPath)
        if let _cell = cell as? DownloadedFileCell {
            let file = fileURLs[indexPath.row]
            _cell.configCell(filePath: file)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet(fileURLs[indexPath.row], at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteFile(fileURLs[indexPath.row], at: indexPath)
        }
    }
}

class DownloadedFileCell: UITableViewCell {
    
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    override func setSelected(_ selected: Bool, animated: Bool) {}
    
    func configCell(filePath: URL) {
        fileNameLbl.text = filePath.lastPathComponent
        fileSizeLbl.text = filePath.fileSizeString
    }
}

extension URL {
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
