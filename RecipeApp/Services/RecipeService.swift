//
//  RecipeService.swift
//  RecipeApp
//
//
//


import Foundation

class RecipeService {
    private let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw AppError.badResponse
        }

        struct Wrapper: Decodable {
            let recipes: [Recipe]
        }

        do {
            return try JSONDecoder().decode(Wrapper.self, from: data).recipes
        } catch {
            throw AppError.malformedData
        }
    }
}
