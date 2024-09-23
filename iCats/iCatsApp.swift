import SwiftUI

@main
struct iCatsApp: App {

	var body: some Scene {

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
