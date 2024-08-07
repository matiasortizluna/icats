//
//  CatViewModel.swift
//  iCats
//
//  Created by Matias Luna on 06/08/2024.
//

import Foundation
import SwiftUI
import SwiftyJSON

class CatViewModel: ObservableObject {
    
    @Published var breeds: [Breed] = []
    
    let apiKey = "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
    let urlString = "https://api.thecatapi.com/v1/breeds?limit=10&page=0"
    
    func fetchBreeds() {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer {
                semaphore.signal()
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            print("Data received: \(data)")
            
            do {
                let json = try JSON(data: data)
                
                for item in json.arrayValue {
                    
                    let breed = Breed(
                        id: item["id"].stringValue,
                        name: item["name"].stringValue,
                        origin: item["origin"].stringValue,
                        temperament: item["temperament"].stringValue,
                        description: item["description"].stringValue,
                        lifeSpan: item["life_span"].stringValue,
                        weight: Weight(imperial: item["weight"]["imperial"].stringValue,
                        metric: item["weight"]["metric"].stringValue),
                        image: item["image"].exists() ? Image(
                            id: item["image"]["id"].stringValue,
                            width: item["image"]["width"].intValue,
                            height: item["image"]["height"].intValue,
                            url: item["image"]["url"].stringValue
                        ) : nil
                    )
                    
                    DispatchQueue.main.async {
                        self.breeds.append(breed)
                    }
                }
                
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        semaphore.wait()
    }
}
