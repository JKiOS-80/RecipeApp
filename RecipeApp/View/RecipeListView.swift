//
//  RecipeListView.swift
//  RecipeApp
//
//
//


import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.error {
                    VStack(spacing: 12) {
                        Text(error.localizedDescription)
                        Button("Try Again") {
                            Task { await viewModel.fetchRecipes() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewModel.recipes.isEmpty {
                    Text("No Recipe Found.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        Section {
                            Picker("Sort", selection: $viewModel.sortType) {
                                ForEach(SortType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        ForEach(viewModel.sortedRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeRowView(recipe: recipe)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchRecipes()
                        try? await Task.sleep(nanoseconds: 800_000_000)
                    }
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                if viewModel.recipes.isEmpty {
                  Task {
                      await viewModel.fetchRecipes()
                  }
                }
            }
        }
    }
}
