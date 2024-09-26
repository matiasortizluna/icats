import SwiftUI
import SDWebImageSwiftUI

struct CatCard: View {
	var breedModel: BreedModel

	var body: some View {
		ZStack {
			VStack(spacing: .zero) {
				ZStack(alignment: .topTrailing) {
					WebImage(url: URL(string: breedModel.image!.url)).resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 120, height: 100)
						.clipShape(RoundedRectangle(cornerRadius: 15))
						.padding(5)
				}
				Text(breedModel.name)
					.font(.system(size: 15))
					.foregroundColor(.black)
					.multilineTextAlignment(.center)
					.lineLimit(2)
			}
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(15)
			.shadow(radius: 5)
		}
	}
}

#Preview {
	CatCard(breedModel: .breedMock)
}
