import Foundation

struct CatImageAPI: Decodable, Equatable {
	let id: String
	let width : Int
	let height: Int
	let url: String
}
