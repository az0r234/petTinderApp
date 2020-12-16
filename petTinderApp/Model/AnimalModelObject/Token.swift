//
//  Token.swift
//  petTinderApp
//
//  Created by Alok Acharya on 10/27/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

//MARK: - Token Data
struct TokenData: Codable {
    let tokenType   : String?
    let expiresIn   : Int?
    let accessToken : String?
    
    enum CodingKeys: String, CodingKey {
        case tokenType   = "token_type"
        case expiresIn   = "expires_in"
        case accessToken = "access_token"
    }
}
