//
//  Recipe.swift
//  RecipeApp
//
//  
//


import Foundation

struct Recipe: Identifiable, Codable {
    let uuid: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    var id: UUID { uuid }

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

