//
//  GeneratedImagesCollectionCell.swift
//  AIAdGenerator
//
//  Created by Amit kumar on 09/04/25.
//

import UIKit

class GeneratedImagesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 4
        self.imgView.clipsToBounds = true
    }
    
    func loadDataForGeneratedImage(base64: String) {
        if let imageData = Data(base64Encoded: base64), let image = UIImage(data: imageData) {
            self.imgView.image = image
        }
    }
}
