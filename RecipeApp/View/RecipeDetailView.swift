//
//  RecipeDetailView.swift
//  RecipeApp
//
//
//


import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var image: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay(ProgressView())
                }

                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                if let sourceURL = recipe.sourceURL {
                    Link("Recipe Source", destination: sourceURL)
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                }

                if let youtubeURL = recipe.youtubeURL {
                    Link("Watch Recipe Video On YouTube", destination: youtubeURL)
                        .font(.body)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Recipe Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let url = recipe.photoURLLarge {
                image = try? await ImageCacheManager.shared.loadImage(from: url)
            }
        }
    }
}
