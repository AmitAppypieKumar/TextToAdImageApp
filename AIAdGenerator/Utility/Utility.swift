//
//  Utility.swift
//  AIAdGenerator
//
//  Created by Amit kumar on 09/04/25.
//

import UIKit
import Foundation
import Photos

class Utility {
    
    static func showSaveActionSheet(for image: UIImage, in viewController: UIViewController) {
        let actionSheet = UIAlertController(title: "Save Image", message: "Do you want to save this image to your gallery?", preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "Save to Gallery", style: .default) { _ in
            Utility.saveImageToGallery(image)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(saveAction)
        actionSheet.addAction(cancelAction)
        // iPad support
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        viewController.present(actionSheet, animated: true)
    }
    
    static func saveImageToGallery(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.async(execute: {
                    Utility.showToast(message: "Image saved to gallery.")
                })
            } else {
                DispatchQueue.main.async(execute: {
                    Utility.showToast(message: "Permission denied to save image.")
                })
            }
        }
    }
    
    static func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let maxWidthPercentage: CGFloat = 0.8
        let maxTitleSize = CGSize(width: UIScreen.main.bounds.width * maxWidthPercentage, height: .greatestFiniteMagnitude)
        let expectedSize = toastLabel.sizeThatFits(maxTitleSize)
        toastLabel.frame = CGRect(
            x: (UIScreen.main.bounds.width - expectedSize.width - 20) / 2,
            y: UIScreen.main.bounds.height - 100,
            width: expectedSize.width + 20,
            height: expectedSize.height + 10
        )

        // ✅ iOS 15+ safe way to get window
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: \.isKeyWindow) {

            window.addSubview(toastLabel)

            UIView.animate(withDuration: 0.5, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }) { _ in
                    toastLabel.removeFromSuperview()
                }
            }
        }
    }
}
