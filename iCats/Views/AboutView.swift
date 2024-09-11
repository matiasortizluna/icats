//
//  AboutView.swift
//  iCats
//
//  Created by Matias Luna on 08/08/2024.
//

import SwiftUI
import SwiftyJSON

struct AboutView: View {
	
	@Environment(\.modelContext) private var modelContext
	@State private var errorMessage: String?

	let networkService = NetworkService(baseNetworkRequest: {request in
		return try await URLSession.shared.data(for: request)
	})

    var body: some View {
        
        NavigationView {
			VStack() {
				Text("This app was developed by Matias Luna on August 2024 as a Swift Challenge for the Mobile Engineer Trainee Role at Sword Health.")
					.foregroundColor(.black)
					.padding()

				Text("Thanks for downloading and testing.")
					.foregroundColor(.black)
					.padding()

				Text("For inquiries please contact the developer at:")
					.foregroundColor(.black)
					.padding()

				Text("matiasortizluna.contacto@gmail.com")
					.foregroundColor(.black)
					.padding()

				Button(action: {
					Task {
						// This implementation should be done on the ViewModel
						let response : Data = try await self.networkService.call(.breeds)
						print(response)
					}
				}) {
					Text("Request with Network Service")
						.font(.system(size: 20.0))
						.foregroundColor(.blue)
						.padding(5)
						.background(
							Rectangle()
								.foregroundColor(.black.opacity(0.2))
								.blur(radius: 20.0)
						)
				}

				Button(action: {
					Task {
						self.fetchBreeds()
					}
				}) {
					Text("Request without Network Service")
						.font(.system(size: 20.0))
						.foregroundColor(.blue)
						.padding(5)
						.background(
							Rectangle()
								.foregroundColor(.black.opacity(0.2))
								.blur(radius: 20.0)
						)
				}
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }

	private func fetchBreeds() {

		let apiKey = "live_ISll8gOWarTBCiBssIqrzkvhzuez2g72xz4WzKx1BkRLXoWIlXD1GTKNklz1ERUr"
		let urlString = "https://api.thecatapi.com/v1/breeds?limit=20&page=0"

		guard let url = URL(string: urlString) else {
			self.errorMessage = "Invalid URL"
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
				DispatchQueue.main.async {
					self.errorMessage = "Network error: \(error.localizedDescription)"
				}
				print("Error: \(error.localizedDescription)")
				return
			}

			guard let data = data else {
				DispatchQueue.main.async {
					self.errorMessage = "No data received"
				}
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
						image: item["image"].exists() ? CatImage(
							id: item["image"]["id"].stringValue,
							width: item["image"]["width"].intValue,
							height: item["image"]["height"].intValue,
							url: item["image"]["url"].stringValue
						) : nil,
						isFavorite: false
					)

					DispatchQueue.main.async {
						self.modelContext.insert(breed)
					}
				}

				DispatchQueue.main.async {
					self.errorMessage = nil
				}

			} catch {
				DispatchQueue.main.async {
					self.errorMessage = "JSON decoding error: \(error.localizedDescription)"
				}
				print("JSON decoding error: \(error.localizedDescription)")
			}
		}

		task.resume()
		semaphore.wait()
	}
}

#Preview {
    AboutView()
}
