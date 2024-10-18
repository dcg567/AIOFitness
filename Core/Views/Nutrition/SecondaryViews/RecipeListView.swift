import SwiftUI

struct RecipeListView: View {
    var recipes: [Recipe]
    
    var body: some View {
        List(recipes, id: \.name) { recipe in
            HStack {
                // If the URL is valid, it loads the image and displays it in the view
                if let imageUrl = URL(string: recipe.imageUrl) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 3)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .padding(.leading, -20)
                    .padding(.trailing, 5)
                }
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text("Calories: \(recipe.calories)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                //checks if the recipe.recipeUrl is valid, and if so, it opens the URL
                Button(action: {
                    if let url = URL(string: recipe.recipeUrl) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .bold()
                }
            }
            .padding()
        }
        .listStyle(.plain)
    }
}
#Preview {
    NutritionView()
}
