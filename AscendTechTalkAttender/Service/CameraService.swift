//
//  CameraService.swift
//  AscendTechTalkAttender
//
//  Created by Hoang Chi Quan on 17/09/2022.
//

import Foundation
import Combine
import UIKit

protocol CameraServiceProtocol {
    func takePhoto() -> AnyPublisher<UIImage, Never>
}

class CameraService: NSObject, CameraServiceProtocol {
    func takePhoto() -> AnyPublisher<UIImage, Never> {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        return Just(UIImage())
            .eraseToAnyPublisher()
    }
}

extension CameraService: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
    }
}

extension CameraService: UINavigationControllerDelegate {
    
}
