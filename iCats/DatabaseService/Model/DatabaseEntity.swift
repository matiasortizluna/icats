public enum DatabaseEntity: String, Equatable {
	case breed = "BreedEntity"
	case catImage = "CatImageEntity"
}

enum DatabaseServiceError: Error, Equatable {
	case empty
}
