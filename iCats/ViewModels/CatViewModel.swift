//
//  CatViewModel.swift
//  iCats
//
//  Created by Matias Luna on 06/08/2024.
//

import Foundation
import SwiftUI

class CatViewModel: ObservableObject {
    
    @Published var catsIDs: [String] = []
    
    let apiKey = "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
    let urlString = "https://api.thecatapi.com/v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=RANDOM&page=0&limit=10"
    
    func getCatsIDs() -> [String] {
        return self.catsIDs
    }
    
    func fetchCatsIDs() {
        
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
                let cats = try JSONDecoder().decode([CatImage].self, from: data)
                DispatchQueue.main.async {
                    for cat in cats {
                        self.catsIDs.append(cat.id)
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        semaphore.wait()
    }
}
