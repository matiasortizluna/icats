import Foundation

struct CatImage: Decodable, Equatable {
	let id: String
	let width: Int
	let height: Int
	let url: String
}
