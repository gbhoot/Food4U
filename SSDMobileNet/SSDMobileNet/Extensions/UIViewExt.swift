//
//  UIViewExt.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/17/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

extension UIView {

    func downloadBackImg(from link: String) {
        guard let url = URL(string: link) else { return }
        //    contentMode = .scaleAspectFit
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.backgroundColor = UIColor(patternImage: image)
                self.contentMode = .scaleToFill
            }
            }.resume()
    }
    
    func addBackground(imageStr: String) {
        // screen width and height:
        let width = self.bounds.size.width
        let height = self.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.downloaded(from: imageStr)
        
        // you can change the content mode:
        imageViewBackground.contentMode = .scaleAspectFill
        imageViewBackground.alpha = 0.4
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    
    // Bind view frame to keyboard
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange(_:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }) { (success) in
            self.layoutIfNeeded()
        }
    }
}
