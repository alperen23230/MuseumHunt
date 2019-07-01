//
//  APIClient.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case getAllBeacons = "/getAllBeacons"
    case getAllMainPageContents = "/getAllMainPageContents"
}

struct APIClient {
    
    var urlHost: String
    var endpoint: EndPoint
    
    var urlComponent: URLComponents {
        get {
            var urlComponent = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = urlHost
            urlComponent.path = endpoint.rawValue
        
            return urlComponent
        }
    }
    
    
}
