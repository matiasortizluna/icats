import SwiftUI

@main
struct CatsApp: App {
	var body: some Scene {
		let databaseService = DatabaseService.live()
		WindowGroup {
			ContentView(
				breedsListViewModel: BreedsListViewModel(
					breedsNetworkService: BreedsListNetworkService.live(
						networkService: NetworkService.live()),
					databaseService: databaseService
				),
				aboutViewModel: AboutViewModel(
					databaseService: databaseService
				)
			)
		}
	}
}
