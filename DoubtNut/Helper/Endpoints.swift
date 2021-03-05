//
//  Endpoints.swift
//  DoubtNut
//
//  Created by Apple on 05/03/21.
//

import Foundation


import Foundation

struct Endpoints {
    
    struct Environment {
        
        static let baseEnvironment = "https://www.hayti.com/"    //"https://www.eboniapp.com/"
        static let webapi = "webapi"
        static let baseURL =  baseEnvironment + webapi
        static let appName =  "IOS"
        static let googleClientId = "1055061992526-37edejdgj0nugp23tgefqhtuc3makq2g.apps.googleusercontent.com"
        
        static let googleAdsHomeUniId = "ca-app-pub-7759679416305464/4851190595"
        
        static let googleAdsCatUniId = "ca-app-pub-7759679416305464/3567040841"
    }
    
    
    struct User {
        
    }
    
    struct Category {
    }
    
    struct Following {
    }
    
    
    struct Setting {
    }
    
    
    
    struct Folder {
    }
    
    
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case connection = "keep-alive"
    case contentLenght = "Content-Lenght"
}

enum ContentType: String {
    case json = "application/json"
}

