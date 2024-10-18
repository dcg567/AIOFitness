//
//  GraphView.swift
//  AIOFitness
//
//
//
//Extension to Progress View
import SwiftUI

struct Graph: View {
    var workoutDays: [Date]
    @Binding var selectedDate: Date

    var body: some View {
        LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], spacing: 5) {
            ForEach(daysInMonth(), id: \.self) { day in
                VStack(spacing: 5) {
                    Spacer()

                    // Display day and month without the year
                    Text(formatDate(day, format: "d       "))
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: self.workoutDays.contains { self.isSameDay($0, as: day) } ? 50 : 10)
                        .foregroundColor(self.workoutDays.contains { self.isSameDay($0, as: day) } ? .greenx2 : .gray)
                         // Add smooth animation
                        .onTapGesture {
                            withAnimation {
                                // Handle tap if needed
                            }
                        }
                }
            }
        }
        .padding()
    }

    private func isSameDay(_ date1: Date, as date2: Date) -> Bool {
        // Check if two dates occur on the same day
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    private func daysInMonth() -> [Date] {
        // Get an array of dates representing all the days in the selected month
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        guard let startOfMonth = calendar.date(from: components) else { return [] }
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return [] }

        let days: [Date] = range.map { day -> Date in
            return calendar.date(bySetting: .day, value: day, of: startOfMonth)!
        }

        return days
    }

    private func formatDate(_ date: Date, format: String) -> String {
        // Format a given date according to a specified format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
