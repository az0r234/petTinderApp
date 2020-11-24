//
//  Constants.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/3/20.
//

import Foundation

struct K {
    
    static let bodyString   = "grant_type=client_credentials&client_id=" + Credential.clientID + "&client_secret=" + Credential.clientSecret
    
    static let tokenString = "https://api.petfinder.com/v2/oauth2/token"
    static let apiString = "https://api.petfinder.com"
    static let defaultUrlPath = "/v2/animals?sort=distance&limit=20&"
    
    
    static let hudLoadingLabel = "Loading Animals"
    
    static let random = "Random"
    static let smallFurry = "Small & Furry"
    static let formattedSmallFurry = "small-furry"
    static let scalesFinsOthers = "Scales, Fins & Other"
    static let FormattedScalesFinsOthers = "scales-fins-other"
    
    
    static let typeBtn = "Animal Type"
    static let breedBtn = "Breed"
    static let colorBtn = "Color"
    static let coatBtn = "Coat Type"
    
    static let sizeBtn = "Size"
    static let genderBtn = "Gender"
    static let ageBtn = "Age"
    static let rangeBtn = "Range"
    
    static let sizeArray = ["Random","Small", "Medium", "Large", "Xlarge"]
    static let genderArray = ["Random", "Male", "Female", "Unknown"]
    static let ageArray = ["Random", "Baby", "Young", "Adult", "Senior"]
    static let rangeArray = (100...500).map { (mile) -> String in return String(mile)}
    
    static let resetBtn = "Reset"
    static let exitBtn = "Exit"
    static let submitBtn = "Submit"
    static let backBtn = "Go Back"
    
    static let specialBtnTitleArray = ["Reset", "Submit", "Exit", "Go Back"]
}



enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HttpHeaderField: String {
    case auth = "Authorization"
}
