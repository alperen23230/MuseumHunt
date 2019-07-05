//
//  APIClient.swift
//  MuseumHunt
//
//  Created by Alperen Ünal on 1.07.2019.
//  Copyright © 2019 Alperen Ünal. All rights reserved.
//

import Foundation
import UIKit

enum EndPoint: String {
    case getAllArtifacts = "/api/artifact/getallartifacts"
    case getLocation = "/api/location/getalllocation"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct APIClient {
    
    static var sharedInstance = APIClient()
    
    var urlComponent = URLComponents()
   
    private init(){
        self.urlComponent.scheme = "https"
        self.urlComponent.host = "beamityapi20190703022513.azurewebsites.net"
    }
    
    mutating func fetchAllArtfiacts(completion: @escaping(Result<[Artifact], Error>)->()){
        urlComponent.path = EndPoint.getAllArtifacts.rawValue
        
        guard let url = urlComponent.url else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let _ = response as? HTTPURLResponse, let jsonData = data  else { return }
                let artifactsData = try? JSONDecoder().decode([Artifact].self, from: jsonData)
                guard let artifacts = artifactsData else { return }
            
                completion(.success(artifacts))
            }
        }.resume()
    }
    mutating func getLocation(completion: @escaping(Result<Location, Error>)->()){
        urlComponent.path = EndPoint.getLocation.rawValue
        
        guard let url = urlComponent.url else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let _ = response as? HTTPURLResponse, let jsonData = data  else { return }
                let locationData = try? JSONDecoder().decode([Location].self, from: jsonData)
                guard let location = locationData else { return }
                completion(.success(location[0]))
            }
        }.resume()
    }
    
}
