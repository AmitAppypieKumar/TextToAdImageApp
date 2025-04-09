//
//  AIAdGeneratorVC.swift
//  AIAdGenerator
//
//  Created by Amit kumar on 09/04/25.
//

import UIKit
import Photos

class AIAdGeneratorVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var viewTop: UIView!
    //View Text To Image
    @IBOutlet weak var labelCreditCount: UILabel!
    @IBOutlet weak var buttonRecent: UIButton!
    //View TextView and Generate Image
    @IBOutlet weak var viewGenerateImageSuper: UIView!
    @IBOutlet weak var viewTextViewBG: UIView!
    @IBOutlet weak var textViewPrompt: UITextView!
    @IBOutlet weak var buttonGenerateImage: UIButton!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var constBottomWarning: NSLayoutConstraint!
    //View Generated Images
    @IBOutlet weak var viewGeneratedImagesSuper: UIView!
    @IBOutlet weak var collectionViewGeneratedImages: UICollectionView!
    @IBOutlet weak var constHeightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var buttonStartOver: UIButton!
    @IBOutlet weak var buttonGenerateMore: UIButton!
    
    var generatedImages: [String] = []
    var callBackForFreeUser: (()->())?
    
    //MARK: View life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialView()
        self.registerCollectionViewCell()
        self.settingCollectionViewLayout()
        self.setupButton()
    }
    
    //MARK: Function setting initial view
    fileprivate func setInitialView() {
        //View TextView and Generate Image
        self.viewTextViewBG.layer.borderWidth = 1
        self.viewTextViewBG.layer.borderColor = UIColor(red: 41/255, green: 103/255, blue: 246/255, alpha: 1.0).cgColor
        self.viewTextViewBG.layer.cornerRadius = 4
        self.viewTextViewBG.clipsToBounds = true
        self.buttonGenerateImage.layer.cornerRadius = 4
        self.labelWarning.text = ""
        self.constBottomWarning.constant = 0
        self.buttonGenerateImage.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0)
        self.buttonGenerateImage.isUserInteractionEnabled = false
        //View Generated Images
        self.viewGeneratedImagesSuper.isHidden = true
        self.buttonStartOver.layer.cornerRadius = 4
        self.buttonGenerateMore.layer.cornerRadius = 4
        // Add toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        self.textViewPrompt.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        self.textViewPrompt.resignFirstResponder()
    }
    
    fileprivate func registerCollectionViewCell() {
        self.collectionViewGeneratedImages.register(UINib(nibName: "GeneratedImagesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GeneratedImagesCollectionCell")
    }
    
    fileprivate func settingCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: (UIScreen.main.bounds.width - 48) / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        self.collectionViewGeneratedImages.collectionViewLayout = layout
    }
    
    fileprivate func openRecentScreen() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyborad.instantiateViewController(withIdentifier: "AIRecentGeneratedAdVC") as? AIRecentGeneratedAdVC {
            if let generatedImages = UserDefaults.standard.stringArray(forKey: "generatedImages") {
                vc.generatedImages = generatedImages
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }
    
    fileprivate func setupButton() {
        self.buttonGenerateImage.setTitle("Generate Ad", for: .normal)
        if !self.textViewPrompt.text.isEmpty && self.textViewPrompt.text != "Enter your prompt" {
            self.buttonGenerateImage.backgroundColor = UIColor.black
            self.buttonGenerateImage.isUserInteractionEnabled = true
        } else {
            self.buttonGenerateImage.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0)
            self.buttonGenerateImage.isUserInteractionEnabled = false
        }
    }
    
    //MARK: IBActions
    @IBAction func tapGenerateImage(_ sender: UIButton) {
        self.view.endEditing(true)
        self.labelWarning.text = ""
        self.constBottomWarning.constant = 0
        self.getGeneratedAd(prompt: self.textViewPrompt.text)
    }
    
    @IBAction func tapStartOver(_ sender: UIButton) {
        self.buttonGenerateImage.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0)
        self.buttonGenerateImage.isUserInteractionEnabled = false
        self.textViewPrompt.text = ""
        self.generatedImages = []
        self.viewGenerateImageSuper.isHidden = false
        self.viewGeneratedImagesSuper.isHidden = true
    }
    
    @IBAction func tapGenerateMore(_ sender: UIButton) {
        self.view.endEditing(true)
        self.getGeneratedAd(prompt: self.textViewPrompt.text)
    }
    
    @IBAction func tapOnTimer(_ sender: UIButton) {
        self.openRecentScreen()
    }
}
//MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods
extension AIAdGeneratorVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
//MARK: UITextViewDelegate Methods
extension AIAdGeneratorVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your prompt" {
            textView.text = ""
            textView.textColor = .black
        } else {
            textView.textColor = .systemGray2
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter your prompt"
            textView.textColor = .systemGray2
        } else {
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textColor = .black
        if !textView.text.isEmpty && textView.text != "Enter your prompt" {
            self.buttonGenerateImage.backgroundColor = UIColor.black
            self.buttonGenerateImage.isUserInteractionEnabled = true
        } else {
            self.buttonGenerateImage.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0)
            self.buttonGenerateImage.isUserInteractionEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 1000
    }
}
//MARK: Rest API
extension AIAdGeneratorVC {
    
    fileprivate func getGeneratedAd(prompt: String, outputFormat: String = "png") {
        let apiKey = "sk-PC8EvBJaePSKBLOqLzGsoL2QHEWiYEX16Hxxi3ujxvdmyWlx"
        let url = URL(string: "https://api.stability.ai/v2beta/stable-image/generate/sd3")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Multipart body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(prompt)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"output_format\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(outputFormat)\r\n".data(using: .utf8)!)

        // Optional: add aspect ratio
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"aspect_ratio\"\r\n\r\n".data(using: .utf8)!)
        body.append("1:1\r\n".data(using: .utf8)!) // square

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Send request
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let weakSelf = self else { return }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                DispatchQueue.main.async {
                    weakSelf.constBottomWarning.constant = 16
                    weakSelf.labelWarning.text = "Your request was rejected as a result of our safety system. Your prompt may contain text that is not allowed by our safety system."
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ImageResponse.self, from: data)
                if let imageStr = decoded.image {
                    DispatchQueue.main.async {
                        weakSelf.generatedImages.append(imageStr)
                        UserDefaults.standard.set(weakSelf.generatedImages, forKey: "generatedImages")
                        weakSelf.viewGenerateImageSuper.isHidden = true
                        weakSelf.viewGeneratedImagesSuper.isHidden = false
                        //Handle dynamic height
                        let height = (UIScreen.main.bounds.width - 48) / 2
                        if ((weakSelf.generatedImages.count) % 2) == 0 {
                            let spacing = ((((weakSelf.generatedImages.count)) / 2) * 16) - 16
                            weakSelf.constHeightCollectionView.constant = (height * CGFloat((weakSelf.generatedImages.count)) / 2) + CGFloat(spacing)
                        } else {
                            let spacing = (((((weakSelf.generatedImages.count)) / 2) + 1) * 16) - 16
                            let heightFactor = ((((weakSelf.generatedImages.count)) / 2) + 1)
                            weakSelf.constHeightCollectionView.constant = (height * CGFloat(heightFactor)) + CGFloat(spacing)
                        }
                        weakSelf.collectionViewGeneratedImages.reloadData()
                        weakSelf.buttonRecent.isHidden = false
                    }
                } else {
                    DispatchQueue.main.async {
                        weakSelf.constBottomWarning.constant = 16
                        weakSelf.labelWarning.text = "Image decoding failed. Please try again later."
                    }
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print(String(data: data, encoding: .utf8) ?? "Invalid response")
            }
        }.resume()
    }
}

