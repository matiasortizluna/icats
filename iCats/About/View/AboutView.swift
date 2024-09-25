import SwiftUI

struct AboutView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var errorMessage: String?

	let networkService = NetworkService.live()

    var body: some View {
        NavigationView {
			VStack(spacing: .zero) {
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
				Divider()

//				TextButton(
//					label: "Request without Network Service",
//					labelColor: .blue,
//					rectangleColor: .black.opacity(0.2),
//					action: {
//						fetchBreeds()
//					}
//				)
//
//				TextButton(
//					label: "Request with Breeds Network Service",
//					labelColor: .blue,
//					rectangleColor: .black.opacity(0.2),
//					action: {
//						Task {
//							let breedsNetworkService = BreedsNetworkService.live(networkService: networkService)
//							let result = try await breedsNetworkService.fetchBreeds(8, 0)
//							print(result)
//						}
//					}
//				)

            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// TODO: could you add a extension String { } with the string literals in this file? Since we can reuse the strings elsewhere
// it might be a good approach to create this extension in a separate file accessible to every view.

#Preview {
	AboutView()
}
