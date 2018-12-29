//
//  DataService.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class DataService {
    
    static let instance = DataService()
    
    func sendRecipeURL(urls: [String], completion: @escaping CompletionHandStrings) {
        var urlFixed: String = urls.first!
        if !(urlFixed.contains("www")) {
            var offset = 0
            if urlFixed.contains("https") {
                offset = 8
            } else {
                offset = 7
            }
            
            let index = urlFixed.index(urlFixed.startIndex, offsetBy: offset)
            urlFixed = urlFixed[..<index] + "www." + urlFixed[index...]
        }
        let urlsFixed = [urlFixed]
        
        let url = URL(string: URL_SERVER_INGREDIENTS)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let bodyData = "urls=\(urlsFixed)"
        request.httpBody = bodyData.data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let retrievedData = data else { return }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: retrievedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                print(jsonData)
                for key in (jsonData?.allKeys)! {
//                    print(jsonData![key])\
                    let directions = jsonData![key] as? [String]
                    completion(true, directions!)
//                    for direction in directions! {
//                        print(direction)
//                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
                completion(false, [""])
            }
        }
        
        task.resume()
    }
}
