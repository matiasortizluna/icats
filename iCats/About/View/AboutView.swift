import SwiftUI

struct AboutView: View {
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
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
// could you add a extension String { } with the string literals in this file? Since we can reuse t he strings elsewhere
// it might be a good approach to create this extension in a separate file accessible to every view.
#Preview {
	AboutView()
}
