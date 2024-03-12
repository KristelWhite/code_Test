//
//  Networking.swift
//  CODETest
//
//  Created by Кристина Пастухова on 12.03.2024.
//

import Foundation

class Networking {
    
    func loadData(isSuccess: Bool, onResponseWasResived: @escaping (_ result: Result<ResponseBody, Error>) -> Void ){
        
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
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                onResponseWasResived(.failure(error))
            } else
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    onResponseWasResived(.failure(NetworkError.badResponse))
                    return
                }
            }
            if let data = data {
                do {
//                    let result = try JSONDecoder().decode(ResponseBody.self, from: data)
                    let result = try ResponseBody.decode(from: data)
                    onResponseWasResived(.success(result))
                } catch {
                    onResponseWasResived(.failure(NetworkError.wrongDataType))
                }
            } else {
                onResponseWasResived(.failure(NetworkError.unknownError))
            }
        })
        
        dataTask.resume()
        
    }
}

private extension Networking {
    
    enum NetworkError: Error {
        case badResponse
        case wrongDataType
        case unknownError
    }
}

