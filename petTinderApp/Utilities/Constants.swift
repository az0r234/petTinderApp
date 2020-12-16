//
//  Constants.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/3/20.
//

import UIKit

struct K {
    
    static let bodyString   = "grant_type=client_credentials&client_id=" + Credential.clientID + "&client_secret=" + Credential.clientSecret
    
    static let tokenString = "https://api.petfinder.com/v2/oauth2/token"
    static let apiString = "https://api.petfinder.com"
    static let defaultUrlPath = "/v2/animals?sort=random&limit=20&"
    
    static let hudLoadingLabel = "Loading Animals"
    
    static let random = "Random"
    static let smallFurry = "Small & Furry"
    static let formattedSmallFurry = "small-furry"
    static let scalesFinsOthers = "Scales, Fins & Other"
    static let formattedScalesFinsOthers = "scales-fins-other"
    
    static let sizeArray = ["Random","Small", "Medium", "Large", "Xlarge"]
    static let genderArray = ["Random", "Male", "Female", "Unknown"]
    static let ageArray = ["Random", "Baby", "Young", "Adult", "Senior"]
    static let rangeArray = (100...500).map { (mile) -> String in return String(mile)}
    
    static let enableLocationError = "Location is denied. Please go to Settings > Privacy > Location Services > Pet Tinder and then enable location services. Thank you!"
    
    static let errorSuggestion = "Please look at the pets you have swiped on for the time being"
    
    static func randomNumGen()->CGFloat{
        return CGFloat(Int.random(in: 1...255))
    }
}



enum ButtonTitles: String {
    case AnimalType = "Animal Type"
    case Breed = "Breed"
    case Color = "Color"
    case Coat = "Coat Type"
    case Reset = "Reset"
    case Exit = "Exit"
    case Submit = "Submit"
    case Back = "Go Back"
    case Error = "Error"
    case Random = "Random"
    case Swiping = "Get Swiping"
    case Ok = "OK"
    case LocationError = "Location Denied"
    case Size = "Size"
    case Gender = "Gender"
    case Age = "Age"
    case Range = "Range"
}

enum SliderTitles: String{
    case Size = "Size"
    case Gender = "Gender"
    case Age = "Age"
    case Range = "Range"
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HttpHeaderField: String {
    case auth = "Authorization"
}
