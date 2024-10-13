import SwiftUI

@main
struct CatsApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView(
				model: BreedsListViewModel(
					breedsNetworkService: BreedsListNetworkService.live(
						networkService: NetworkService.live()),
					databaseService: DatabaseService.live()
				)
			)
		}
	}
}
