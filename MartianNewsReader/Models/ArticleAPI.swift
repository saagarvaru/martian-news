//
//  ArticleAPI.swift
//  MartianNewsReader
//
//  Created by Saagar Varu on 7/27/19.
//  Copyright © 2019 NYTimes. All rights reserved.
//

import Foundation
import UIKit

let url = URL(string: "http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist")!

final class ArticleAPI {
    
    static let imageManager = ImageManager()
    
    static func getData(completion: @escaping ([Article]?) -> Void) {
        // Define
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            
            //exit command
            guard let responseData = data else  { return completion(nil)}
            
            do {
                let articles = try PropertyListDecoder().decode([Article].self, from: responseData)
                completion(articles)
            } catch let err {
                completion(nil)
            }
        }).resume()
    }
}

final class ImageManager {
    
    // Dictionary
    var images: [URL : UIImage] = [:]
    
    func download(with url: URL, with completion: @escaping (UIImage?) -> Void) {
        
        if (images[url] == nil) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let imageData = data else { return completion(nil) }
                
                let image = UIImage(data: imageData)
                self.images[url] = image
                completion(image)
            }).resume()
        } else {
            completion(images[url])
        }
        
        
    }
}
