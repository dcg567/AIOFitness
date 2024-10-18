import Foundation

struct RecipesResponse: Codable {
    let hits: [RecipeHit]
}

struct RecipeHit: Codable {
    let recipe: EdamamRecipe
}

struct EdamamRecipe: Codable {
    let label: String
    let calories: Double
    let image: String
    let url: String
}

struct Recipe {
    let name: String
    let calories: Int
    let imageUrl: String
    let recipeUrl: String
}
