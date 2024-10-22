public enum DatabaseEntity: String, Equatable {
	case breed = "BreedEntity"
	case catImage = "CatImageEntity"
	case mock = "MockEntity"
}

enum DatabaseServiceError: Error, Equatable {
	case empty
	case wrongTransformation
	case noEntity
}
