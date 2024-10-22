import SwiftUI

struct AboutView: View {
	@State var model: AboutViewModel

    var body: some View {
        NavigationView {
			VStack(spacing: .zero) {
				Text(String.aboutSummary)
					.padding()

				Text(String.aboutThanks)
					.padding()

				Text(String.aboutContactDeveloper)
					.padding()

				Text(String.developerEmail)
					.padding()

				TextButton(
					label: "Clear Database",
					labelColor: .white,
					rectangleColor: .red,
					action: {
						Task {
							await model.clearDatabaseButtonTapped()
						}
					}
				)
            }
			.navigationTitle(String.about)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
	AboutView(
		model: AboutViewModel(
			databaseService: DatabaseService.live()
		)
	)
}
