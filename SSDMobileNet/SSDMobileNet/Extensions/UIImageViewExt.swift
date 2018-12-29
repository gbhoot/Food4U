//
//  UIImageViewExt.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/17/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        contentMode = .scaleAspectFit
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}
