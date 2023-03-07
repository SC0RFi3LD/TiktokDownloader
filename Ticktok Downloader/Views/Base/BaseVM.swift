//
//  BaseVM.swift
//  Ticktok Downloader
//
//  Created by Kokila Ekanayake on 2023-02-20.
//

import Foundation

class BaseVM {
    
    func hadleErrorResponse(_ error: Any?, completion: CompletionHandler) {
        if let data = error as? Data {
            let errorResponse = try? JSONDecoder().decode(ErrorModel.self, from: data)
            let commonResponse = try? JSONDecoder().decode(CommonModel.self, from: data)
            if let _validationErros = errorResponse?.error {
                if _validationErros.isEmpty {
                    completion(false, 400,commonResponse?.errorMessage ?? commonResponse?.error ?? commonResponse?.message ?? "Error is corrupted")
                    
                } else {
                    completion(false, 400, errorResponse?.error ?? "")
                }
            } else {
                completion(false, 400,commonResponse?.errorMessage ?? commonResponse?.error ?? commonResponse?.message ?? commonResponse?.messageText ?? "Error is corrupted")
            }
        } else {
            completion(false, 422, "Error is corrupted")
        }
    }
}
