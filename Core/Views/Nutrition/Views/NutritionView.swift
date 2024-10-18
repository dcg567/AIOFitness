import SwiftUI
//UI Nutrition View
struct NutritionView: View {
    @StateObject private var viewModel = NutritionViewModel()
    
    var body: some View {
        VStack {
            
            Text("Recipes & Nutrition")
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
                .padding(.trailing, 70)
                .padding(.bottom, -10)
                .padding(.leading, 15)
                .padding(.top, 39)
            
            //binds the query state variable and triggers the fetchRecipes method when the search action is performed.
            SearchBarView(query: $viewModel.query, searchAction: viewModel.fetchRecipes)
            
            if viewModel.recipes.isEmpty {
                ProgressView()
            } else {
                RecipeListView(recipes: viewModel.recipes)
            }
        }
        //triggers the fetchRecipes method of the view model to load recipes when the view initially appears
        .onAppear {
            viewModel.fetchRecipes()
        }.preferredColorScheme(.dark)
    }
}

#Preview {
    NutritionView()
}

