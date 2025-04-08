//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//
//

import XCTest
@testable import RecipeApp

@MainActor
final class RecipeAppTests: XCTestCase {

    func testMalformedDataThrowsError() async {
        let service = RecipeServiceMock(responseType: .malformed)
        let vm = RecipeListViewModel(service: service)

        await vm.fetchRecipes()
        XCTAssertEqual(vm.error, .malformedData)
    }

    func testEmptyDataHandledProperly() async {
        let service = RecipeServiceMock(responseType: .empty)
        let vm = RecipeListViewModel(service: service)

        await vm.fetchRecipes()
        XCTAssertTrue(vm.recipes.isEmpty)
        XCTAssertNil(vm.error)
    }

    func testSuccessfulDataFetch() async {
        let service = RecipeServiceMock(responseType: .success)
        let vm = RecipeListViewModel(service: service)

        await vm.fetchRecipes()
        XCTAssertEqual(vm.recipes.count, 1)
        XCTAssertEqual(vm.recipes.first?.name, "Test Recipe")
        XCTAssertNil(vm.error)
    }

    func testApplySortingByName() async {
        let vm = RecipeListViewModel()
        vm.recipes = [
            Recipe(uuid: UUID(), name: "Banana Cake", cuisine: "French", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(uuid: UUID(), name: "Apple Pie", cuisine: "American", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        vm.sortType = .name
        XCTAssertEqual(vm.sortedRecipes.map { $0.name }, ["Apple Pie", "Banana Cake"])
    }

    func testApplySortingByCuisine() async {
        let vm = RecipeListViewModel()
        vm.recipes = [
            Recipe(uuid: UUID(), name: "Sushi", cuisine: "Japanese", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(uuid: UUID(), name: "Tacos", cuisine: "Mexican", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
        vm.sortType = .cuisine
        XCTAssertEqual(vm.sortedRecipes.map { $0.cuisine }, ["Japanese", "Mexican"])
    }
}
