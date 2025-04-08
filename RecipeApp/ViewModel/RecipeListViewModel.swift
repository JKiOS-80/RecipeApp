//
//  RecipeListViewModel.swift
//  RecipeApp
//
//
//


import Foundation

enum SortType: String, CaseIterable, Identifiable {
    case name = "Alphabetical"
    case cuisine = "Cuisine"

    var id: String { self.rawValue }
}

@MainActor
class RecipeListViewModel: ObservableObject {
  
  private let service: RecipeService

  init(service: RecipeService = RecipeService()) {
      self.service = service
  }
  
    @Published var recipes: [Recipe] = []
    @Published var sortedRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: AppError?
    @Published var sortType: SortType = .name {
        didSet {
            applySorting()
        }
    }

    @Published private(set) var hasFetchedOnce = false
    private var isFetching = false
    func fetchIfNeededOnce() async {
        guard !hasFetchedOnce else { return }
        hasFetchedOnce = true
        await fetchRecipes()
    }

    func fetchRecipes() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }

        isLoading = true
        error = nil

        do {
            let data = try await service.fetchRecipes()
            recipes = data
            applySorting()
        } catch let appError as AppError {
            error = appError
        } catch let unknownError {
            error = .unknown
        }

        isLoading = false
    }

    private func applySorting() {
        switch sortType {
        case .name:
            sortedRecipes = recipes.sorted { $0.name < $1.name }
        case .cuisine:
            sortedRecipes = recipes.sorted { $0.cuisine < $1.cuisine }
        }
    }
}
