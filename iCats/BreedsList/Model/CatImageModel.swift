import Foundation

struct CatImageModel {
	let id: String
	let width: Int
	let height: Int
	let url: String

	init(id: String, width: Int, height: Int, url: String) {
		self.id = id
		self.width = width
		self.height = height
		self.url = url
	}
}
