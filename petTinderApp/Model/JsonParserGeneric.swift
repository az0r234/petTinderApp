//
//  Bindable.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/16/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

struct JSONParser{
    typealias ResultBlock<T> = (Result <T, Error>) -> Void
    
    func downloadList<T: Decodable>(of type: T.Type, from url: String, completion: @escaping ResultBlock<T>){
        FetchManager().fetchToken { (res) in
            switch res {
            case .success(let token):
                guard let tokenData = token.accessToken, let bearer = token.tokenType else { return }
                guard let url = URL(string: url) else { return }

                var request = URLRequest(url: url)
                request.httpMethod = HttpMethod.get.rawValue
                let value = "\(bearer) \(tokenData)"
                request.addValue(value, forHTTPHeaderField: HttpHeaderField.auth.rawValue)

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let err = error{
                        completion(.failure(err))
                        return
                    }

                    guard let safeData = data else { return }

                    do {
                        let decodedData: T = try JSONDecoder().decode(T.self, from: safeData)
                        completion(.success(decodedData))
                    }
                    catch let decodingError {
                        completion(.failure(decodingError))
                    }
                }
                task.resume()
            case .failure(let tokenError):
                completion(.failure(tokenError))
            }
        }
    }
    
    
}
