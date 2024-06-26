//
//  ImagesProvide.swift
//  searchMedia
//
//  Created by snydia on 12.04.2024.
//

import UIKit

final class ImagesProvider {
    private var cashe: [URL: UIImage] = [:]
    
    func image(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = cashe[url] {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response,error) in
            if error != nil {
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
                self?.cashe[url] = image
            } else {
                completion(nil)
            }
        }.resume()
    }
}
