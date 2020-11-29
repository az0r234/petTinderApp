//
//  ParseManager.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/17/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

struct FetchManager {
    //MARK: - Token Manager
    let tokenURL = K.tokenString
    
    func fetchToken(completion: @escaping (TokenData?, Error?) -> ()){
        guard let url = URL(string: tokenURL) else {return}
        guard let body = K.bodyString.data(using: .utf8) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                return
            }
            guard let safeData = data else {return}
            do{
                let decodedData = try JSONDecoder().decode(TokenData.self, from: safeData)
                let tokenModel = TokenData(tokenType: decodedData.tokenType, expiresIn: decodedData.expiresIn, accessToken: decodedData.accessToken)
                completion(tokenModel, nil)
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //MARK: - Animal Data Manager
    func fetchAnimalData(url: String, completion: @escaping (AnimalData?, Error?) -> ()){
        JSONParser().downloadList(of: AnimalData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case let .success(animalData):
                completion(animalData, nil)
            }
        }
    }
    
    //MARK: - Animal Types Manager
    func fetchAnimalTypes(url: String, completion: @escaping (AnimalTypesData?, Error?) -> ()){
        JSONParser().downloadList(of: AnimalTypesData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case let .success(animalTypesData):
                completion(animalTypesData, nil)
            }
        }
    }
    
    //MARK: - Breed Manager
    func fetchBreed(url: String, completion: @escaping (BreedModel?, Error?) -> ()){
        JSONParser().downloadList(of: BreedModel.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case let .success(breed):
                completion(breed, nil)
            }
        }
    }
    
    //MARK: - Organization Data Manager
    func fetchOrganizationData(url: String, completion: @escaping (OrganizationData?, Error?) -> ()){
        JSONParser().downloadList(of: OrganizationData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(nil, error)
            case let .success(organizationData):
                completion(organizationData, nil)
            }
        }
    }
}
