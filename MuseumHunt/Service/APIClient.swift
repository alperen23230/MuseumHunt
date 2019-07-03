//
//  APIClient.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case getAllArtifacts = "/api/artifact/getallartifacts"
}

struct APIClient {
    
    var urlHost = "https://beamityapi20190703022513.azurewebsites.net/"
    var endpoint: EndPoint
    
    var urlComponent: URLComponents {
        get{
            var urlComponent = URLComponents()
            urlComponent.scheme = "https"
            urlComponent.host = urlHost
            urlComponent.path = endpoint.rawValue
            
            return urlComponent
        }
    }
    
   
    
}
