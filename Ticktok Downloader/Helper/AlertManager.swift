//
//  AlertManager.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation
import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    private init() {}
    
    func singleActionMessage(title: String, message: String, action: String, vc: UIViewController) {
        self.checkAndDismissAlert()
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func multipleActionMessage(title: String, message: String, actions: [String], vc: UIViewController, completion: @escaping AlertActionHandler) {
        self.checkAndDismissAlert()
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: { (_action) in
                completion(_action.title ?? "")
            }))
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    private func checkAndDismissAlert() {
        guard let presented = UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController as? UIAlertController else { return }
        presented.dismiss(animated: true, completion: nil)
    }
}
