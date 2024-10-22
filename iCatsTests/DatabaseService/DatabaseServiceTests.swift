import XCTest
@testable import iCats

final class DatabaseServiceTests: XCTestCase {

	func testInit() async {
		let persistentContainer = DatabaseService.liveContainer("MockModel")
		XCTAssertNotNil(persistentContainer)

		let sut = DatabaseService.live(persistentContainer: persistentContainer)
		XCTAssertNotNil(sut)

		let context = persistentContainer.viewContext
		XCTAssertNotNil(context)

		await self.clearDB()
	}

	override func tearDown() async throws{
		await clearDB()
		try await super.tearDown()
	}

	func testFetchObjects() async throws {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))

		let objects = try await sut.fetchObjects(.mock, nil)
		let result = objects.count
		XCTAssertEqual(result, 0)
	}

	func testCreateObject_And_Save() async throws {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))

		let newObject = try await sut.createObject(.mock)
		XCTAssertNotNil(newObject)

		try await sut.save()

		let objects = try await sut.fetchObjects(.mock, nil)
		let result = objects.count
		XCTAssertEqual(result, 1)
	}

	func testCount() async throws {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))

		let result = try await sut.count(.mock)
		XCTAssertEqual(result, 0)
	}

	func testEditObject() async throws {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))

		var items = try await sut.count(.mock)
		XCTAssertEqual(items, 0)

		let newObject = try await sut.createObject(.mock) as? MockEntity
		newObject?.text = "Text"
		try await sut.save()

		items = try await sut.count(.mock)
		XCTAssertEqual(items, 1)

		newObject?.text = "Text Edited"
		try await sut.save()

		items = try await sut.count(.mock)
		XCTAssertEqual(items, 1)

		var objects = try await sut.fetchObjects(.mock, nil) as? [MockEntity]
		var object = try XCTUnwrap(objects?.first)
		XCTAssertEqual(object.text, "Text Edited")
	}

	func testDeleteObjects() async throws {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))

		var result = try await sut.count(.mock)
		XCTAssertEqual(result, 0)

		let _ = try await sut.createObject(.mock) as? MockEntity
		try await sut.save()

		result = try await sut.count(.mock)
		XCTAssertEqual(result, 1)

		try await sut.deleteObjects(.mock)

		result = try await sut.count(.mock)
		XCTAssertEqual(result, 0)
	}

	private func clearDB() async {
		let sut = DatabaseService.live(persistentContainer: DatabaseService.liveContainer("MockModel"))
		await sut.deleteAllOf([.mock])
	}
}
