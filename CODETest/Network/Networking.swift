//
//  Networking.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation

class Networking {
    
    var urlCache : URLCache {
        URLCache.shared
    }
    
    func loadData(isSuccess: Bool, onResponseWasReseived: @escaping (_ result: Result<ResponseBody, Error>) -> Void ){
        
        let preferHeader: String
        
        if isSuccess {
            preferHeader = "code=200, example=success"
        } else {
            preferHeader = "code=500, example=error-500"
        }
        
        let headers = ["Accept": "application/json", "Prefer": preferHeader]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        do {
            let request = request as URLRequest
            
            if let cachedResponse = getCachedResponce(forRequest: request) {
                let decodedData = try ResponseBody.decode(from: cachedResponse.data)
                onResponseWasReseived(.success(decodedData))
                return
            }
            
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if let error = error {
                    onResponseWasReseived(.failure(error))
                } else
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode == 200 else {
                        print(httpResponse)
                        onResponseWasReseived(.failure(NetworkError.badResponse))
                        return
                    }
                }
                if let data = data {
                    do {
                        //                        let result = try JSONDecoder().decode(ResponseBody.self, from: data)
                        let result = try ResponseBody.decode(from: data)
                        //   сохраняем запрос в кеш
                        self.saveCachedResponse(response: response, data: data, forRequest: request)
                        onResponseWasReseived(.success(result))
                    } catch {
                        onResponseWasReseived(.failure(NetworkError.wrongDataType))
                    }
                } else {
                    onResponseWasReseived(.failure(NetworkError.unknownError))
                }
            }
            
            dataTask.resume()
        }
        catch {
            onResponseWasReseived(.failure(error))
        }
    }
}

private extension Networking {
    
    enum NetworkError: Error {
        case badResponse
        case wrongDataType
        case unknownError
    }
}

//MARK: - Cached logic

private extension Networking {
    
    func saveCachedResponse (response: URLResponse?, data: Data?, forRequest request: URLRequest) {
        guard let response = response, let data = data else { return }
        let cachedData = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedData, for: request)
    }
    
    func getCachedResponce (forRequest request: URLRequest) -> CachedURLResponse? {
        return urlCache.cachedResponse(for: request)
    }
}

