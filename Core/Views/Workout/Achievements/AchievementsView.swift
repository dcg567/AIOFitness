import SwiftUI

//display individual achievements
struct AchievementView: View {
    let title: String
    let desc: String
    let isCompleted: Bool // Flag to determine if achievement is completed
    let progress: String // Current progress
    let imageName: String
    let imageSize: CGSize
    let backgroundColor: Color
    let borderColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "\(imageName)" : imageName)
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .bold()
                .frame(width: imageSize.width, height: imageSize.height) // Set the frame size for the image
                .foregroundColor(isCompleted ? .greenx2 : .gray)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(borderColor.opacity(isCompleted ? 1.0 : 0.1), lineWidth: 2)// Added a stroke around the circle
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .bold()
                    .foregroundColor(isCompleted ? .white : .gray)
                Text(desc)
                    .foregroundColor(.darkGrey)
                    .italic()
                Text(progress)
                    .font(.caption)
                    .foregroundColor(.darkGrey)
            }
            Spacer()
        }
        .padding(8)
        .background(backgroundColor.opacity(isCompleted ? 1.0 : 0.3))
        .cornerRadius(8) // Added corner radius
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor.opacity(isCompleted ? 1.0 : 0.1), lineWidth: 2) // Added border
        )
    }
}

