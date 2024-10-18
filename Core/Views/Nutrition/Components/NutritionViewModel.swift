import SwiftUI

class NutritionViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var query: String = "Protein" // Default query
    
    //fetch recipes based on the current query
    func fetchRecipes() {
        let apiKey = "08657794041ea70441e5438e8f6969f6"
        let appId = "c8dda16c"
        let urlString = "https://api.edamam.com/search?q=\(query)&app_id=\(appId)&app_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Decode the JSON response into a RecipesResponse object
            do {
                let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
                // Update the recipes array on the main thread
                DispatchQueue.main.async {
                    self.recipes = recipesResponse.hits.map { hit in
                        let calories = Int(hit.recipe.calories)
                        return Recipe(name: hit.recipe.label, calories: calories, imageUrl: hit.recipe.image, recipeUrl: hit.recipe.url)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        // Resume the URL session task to initiate the API request
        task.resume()
    }
}

