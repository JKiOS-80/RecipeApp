//
//  MockResponseType.swift
//  RecipeApp
//
//
//


import Foundation
@testable import RecipeApp

enum MockResponseType {
    case success, empty, malformed
}

class RecipeServiceMock: RecipeService {
    private let responseType: MockResponseType

    init(responseType: MockResponseType) {
        self.responseType = responseType
    }

    override func fetchRecipes() async throws -> [Recipe] {
        switch responseType {
        case .success:
            return [
                Recipe(
                    uuid: UUID(),
                    name: "Test Recipe",
                    cuisine: "Mock",
                    photoURLSmall: nil,
                    photoURLLarge: nil,
                    sourceURL: nil,
                    youtubeURL: nil
                )
            ]
        case .empty:
            return []
        case .malformed:
            throw AppError.malformedData
        }
    }
}
