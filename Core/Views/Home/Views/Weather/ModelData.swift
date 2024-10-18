//
//  ModelData.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//

import Foundation

// Variable to hold the decoded weather data for preview purposes
var previewWeather: ResponseBody = load("weatherData.json")

// Function to load and decode a JSON file from the main bundle
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    // Attempt to find the JSON file within the main bundle using the provided filename
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            // If the file cannot be found crash the application and provide an error message
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    // Attempt to read the data from the file URL
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    // Attempt to decode the data into the specified decodable type T
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
