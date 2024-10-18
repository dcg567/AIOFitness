import SwiftUI
//SearchBar (Nutrition) UI
struct SearchBarView: View {
    @Binding var query: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack{
            TextField("Enter query", text: $query, onCommit: searchAction)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(Color.white)
                .opacity(0.6)
                .autocapitalization(.sentences)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 3)
                .padding(.leading, 5)
            
            Button(action: searchAction) {
                Text("Search")
                    .frame(height: 5)
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 3)
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.greenx2)
                    .cornerRadius(8)
                    .padding(.leading, -30)
                    .padding(.bottom, -2)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 3)
            .padding()
        }
    }
}
