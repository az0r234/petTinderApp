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
    func fetchSomeToken(completion: @escaping (Error?) -> ()){
        guard let url = URL(string: K.tokenString), let body = K.bodyString.data(using: .utf8) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(err)
            }
            
            guard let safeData = data else {return}
            
            do{
                let decodedData = try JSONDecoder().decode(TokenData.self, from: safeData)
                let tokenModel = TokenData(tokenType: decodedData.tokenType, expiresIn: decodedData.expiresIn, accessToken: decodedData.accessToken)
                
                let encodedTokenModel = try PropertyListEncoder().encode(tokenModel)
                UserDefaults.standard.setValue(encodedTokenModel, forKey: "token")
            }catch let jsonError{
                completion(jsonError)
            }
        }
        task.resume()
    }
    
    //MARK: - Animal Data Manager
    func fetchAnimalData(url: String, completion: @escaping (Result<AnimalData, Error>) -> ()){
        JSONParser().downloadList(of: AnimalData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(animalData):
                completion(.success(animalData))
            }
        }
    }
    
    //MARK: - Animal Types Manager
    func fetchAnimalTypes(url: String, completion: @escaping (Result<AnimalTypesData, Error>) -> ()){
        JSONParser().downloadList(of: AnimalTypesData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(animalTypesData):
                completion(.success(animalTypesData))
            }
        }
    }
    
    //MARK: - Breed Manager
    func fetchBreed(url: String, completion: @escaping (Result<BreedModel, Error>) -> ()){
        JSONParser().downloadList(of: BreedModel.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(breed):
                completion(.success(breed))
            }
        }
    }
    
    //MARK: - Organization Data Manager
    func fetchOrganizationData(url: String, completion: @escaping (Result<OrganizationData, Error>) -> ()){
        JSONParser().downloadList(of: OrganizationData.self, from: url) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(organizationData):
                completion(.success(organizationData))
            }
        }
    }
}
