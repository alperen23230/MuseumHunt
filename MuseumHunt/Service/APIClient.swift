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
    case getAllLocation = "/api/location/getallLocation"
    case getMainPageContent = "/api/content/gethomecontents"
    case getAllBeacons = "/api/beacon/getallbeacons"
    case getContentWithBeacon = "/api/relation/getcontentwithbeacon"
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
    
    //GET Request
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
    //GET Request
    mutating func getAllLocation(completion: @escaping(Result<[Location], Error>)->()){
        urlComponent.path = EndPoint.getAllLocation.rawValue
        
        guard let url = urlComponent.url else { return }
        
        let project = Project()
 
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(project)
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let httpResponse = response as? HTTPURLResponse, let jsonData = data  else { return }
                print(httpResponse.statusCode)
                let locationData = try? JSONDecoder().decode([Location].self, from: jsonData)
                guard let locations = locationData else { return }
                    completion(.success(locations))
            }
            }.resume()
    }
    //GET Request
    mutating func getMainPageContent(location: LocationJSONModel, completion: @escaping(Result<[MainPageContent], Error>)->()){
        urlComponent.path = EndPoint.getMainPageContent.rawValue
        
        guard let url = urlComponent.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(location)
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let _ = response as? HTTPURLResponse, let jsonData = data  else { return }
                let mainPageContentData = try? JSONDecoder().decode([MainPageContent].self, from: jsonData)
                guard let mainPageContents = mainPageContentData else { return }
                completion(.success(mainPageContents))
            }
            }.resume()
    }
    //GET Request
    mutating func getAllBeacons(completion: @escaping(Result<[Beacon], Error>)->()){
        urlComponent.path = EndPoint.getAllBeacons.rawValue
        
        guard let url = urlComponent.url else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let _ = response as? HTTPURLResponse, let jsonData = data  else { return }
                let beaconData = try? JSONDecoder().decode([Beacon].self, from: jsonData)
                guard let allBeacons = beaconData else { return }
                completion(.success(allBeacons))
            }
            }.resume()
    }
    //POST Request
    mutating func getContentWithBeacon(beacon: Beacon, completion: @escaping(Result<Content, Error>)->()){
        
        urlComponent.path = EndPoint.getContentWithBeacon.rawValue
        
        guard let url = urlComponent.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(beacon)
        
        URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
            if error != nil{
                completion(.failure(error!))
                print(error!)
            } else{
                guard let httpResponse = response as? HTTPURLResponse, let jsonData = data  else { return }
                print(httpResponse.statusCode)
                let contentData = try? JSONDecoder().decode(Content.self, from: jsonData)
                guard let content = contentData else { return }
                completion(.success(content))
            }
            }.resume()
    }
}
