//
//  ImageLoader.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation
import UIKit

struct ImageLoader {
    var urlCache: URLCache {
        URLCache.shared
    }
    
    var session = URLSession(configuration: .default)
    
    func loadImage( from url: URL, _ onLoadWasCompleted: @escaping (_ result: Result<UIImage, Error>) -> Void ) {
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = getCachedResponce(forRequest: request), let image = UIImage(data: cachedResponse.data) {
            onLoadWasCompleted(.success(image))
            return
        }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                onLoadWasCompleted(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                saveCachedResponse(response: response, data: data, forRequest: request)
                onLoadWasCompleted(.success(image))
            }
            
        }.resume()
    }
}


//MARK: - Cached logic

private extension ImageLoader {
    
    func saveCachedResponse (response: URLResponse?, data: Data?, forRequest request: URLRequest) {
        guard let response = response, let data = data else { return }
        let cachedData = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedData, for: request)
    }
    
    func getCachedResponce (forRequest request: URLRequest) -> CachedURLResponse? {
        return urlCache.cachedResponse(for: request)
    }
}
