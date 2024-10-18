import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.white))
                .fontWeight(.semibold)
                .font(.footnote)

            // Conditional display of secure or regular text field
            if isSecureField {
                // Secure field for password input
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.darkGrey)
                            .opacity(0.5)
                            .font(.system(size: 14))
                    }
                    SecureField("", text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(.darkGrey)
                }
            } else {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.darkGrey)
                            .opacity(0.5)
                            .font(.system(size: 14))
                    }
                    TextField("", text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(.darkGrey)
                }
            }
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "email@mail.com")
}
