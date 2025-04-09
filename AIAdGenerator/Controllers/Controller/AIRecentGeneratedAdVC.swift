//
//  AIRecentGeneratedAdVC.swift
//  AIAdGenerator
//
//  Created by Amit kumar on 09/04/25.
//

import UIKit

class AIRecentGeneratedAdVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var collectionViewRecent: UICollectionView!
    
    var generatedImages: [String] = []
    
    //MARK: View life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionViewCell()
        self.settingCollectionViewLayout()
    }
    
    //MARK: Function setting initial view
    fileprivate func registerCollectionViewCell() {
        self.collectionViewRecent.register(UINib(nibName: "GeneratedImagesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GeneratedImagesCollectionCell")
    }
    
    fileprivate func settingCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 32) / 2, height: (UIScreen.main.bounds.width - 32) / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        self.collectionViewRecent.collectionViewLayout = layout
    }
    
    //MARK: IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
//MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods
extension AIRecentGeneratedAdVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.generatedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneratedImagesCollectionCell", for: indexPath) as? GeneratedImagesCollectionCell {
            cell.loadDataForGeneratedImage(base64: self.generatedImages[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageData = Data(base64Encoded: self.generatedImages[indexPath.item]), let image = UIImage(data: imageData) {
            Utility.showSaveActionSheet(for: image, in: self)
        }
    }
}
