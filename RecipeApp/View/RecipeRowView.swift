//
//  RecipeRowView.swift
//  RecipeApp
//
//
//


import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @State private var image: UIImage?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(ProgressView())
                }
            }
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            Task {
                if let url = recipe.photoURLSmall {
                    do {
                        image = try await ImageCacheManager.shared.loadImage(from: url)
                    } catch {
                        print("Image load error:", error.localizedDescription)
                    }
                }
            }
        }
    }
}
