import SwiftUI

@main
struct CatsApp: App {
	// TODO: Please remove this line
	var body: some Scene {
		// TODO: Please remove this line
		WindowGroup {
			ContentView(
				model: BreedsListViewModel(
					breedsNetworkService: BreedsListNetworkService.live(
						networkService: NetworkService.live()
					)
				)
			)
		}
	}
}
