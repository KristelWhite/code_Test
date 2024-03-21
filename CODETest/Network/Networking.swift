//
//  Networking.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation

class Networking {
    
    private var urlCache: URLCache {
        URLCache.shared
    }
    
    func loadData(isSuccess: Bool, onResponseWasReceived: @escaping (Result<ResponseBody, Error>) -> Void) {
        
        let preferHeader = isSuccess ? "code=200, example=success" : "code=500, example=error-500"
        let headers = ["Accept": "application/json", "Prefer": preferHeader]
        
        guard let url = URL(string: "https://stoplight.io/mocks/kode-api/trainee-test/331141861/users") else {
            onResponseWasReceived(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        if let cachedResponse = getCachedResponse(forRequest: request) {
            do {
                let decodedData = try ResponseBody.decode(from: cachedResponse.data)
                onResponseWasReceived(.success(decodedData))
                return
            } catch {
                onResponseWasReceived(.failure(NetworkError.wrongDataType))
                return
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onResponseWasReceived(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    onResponseWasReceived(.failure(NetworkError.badResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    onResponseWasReceived(.failure(NetworkError.unknownError))
                }
                return
            }
            
            do {
                let result = try ResponseBody.decode(from: data)
                self.saveCachedResponse(response: response, data: data, forRequest: request)
                DispatchQueue.main.async {
                    onResponseWasReceived(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    onResponseWasReceived(.failure(NetworkError.wrongDataType))
                }
            }
        }
        
        dataTask.resume()
    }
}

// MARK: - Error Handling

extension Networking {
    enum NetworkError: Error {
        case invalidURL
        case badResponse
        case wrongDataType
        case unknownError
    }
}

// MARK: - Cache Management

private extension Networking {
    func saveCachedResponse(response: URLResponse?, data: Data?, forRequest request: URLRequest) {
        guard let response = response, let data = data else { return }
        let cachedData = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedData, for: request)
    }
    
    func getCachedResponse(forRequest request: URLRequest) -> CachedURLResponse? {
        urlCache.cachedResponse(for: request)
    }
}
