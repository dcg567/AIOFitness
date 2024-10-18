//
//  WeatherManager.swift
//  AIOFitness
//
//  Created by Sergiu Lucaci on 18/01/2024.
//
//  Some weather code segments have been sourced from third parties

import Foundation
import CoreLocation

class WeatherManager {
    // Fetches weather data from the OpenWeatherMap API
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        // Constructs the URL with latitude and longitude, throws an error if URL creation fails
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=078c085ce86becdea8493d46c6dfa7b0&units=metric") else {
            throw WeatherError.missingURL
        }
        // Fetch the data from the URL and parse the JSON
        let data = try await fetchData(with: url)
        return try parseWeather(data: data)
    }
    
    // Fetch data from the server with error handling
    private func fetchData(with url: URL) async throws -> Data {
        // HTTP request and capture the returned data and response
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        // Makes sure the response is an HTTPURLResponse and handle different status codes
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.badResponse
        }
        // Different handle status codes
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 400...499:
            throw WeatherError.clientError(httpResponse.statusCode)
        case 500...599:
            throw WeatherError.serverError(httpResponse.statusCode)
        default:
            throw WeatherError.unexpectedStatusCode(httpResponse.statusCode)
        }
    }
    
    // Method to parse the JSON data into a ResponseBody object
    private func parseWeather(data: Data) throws -> ResponseBody {
        do {
            return try JSONDecoder().decode(ResponseBody.self, from: data)
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}

// Error types for handling different error cases in the weather fetching process
enum WeatherError: Error {
    case missingURL
    case badResponse
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case decodingError(Error)
}

// Model of the response body with improved usage
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    // Data model for the JSON response body from the OpenWeather API
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
        
        // Properties to easily access values without underscore naming
        var feelsLike: Double { feels_like }
        var tempMin: Double { temp_min }
        var tempMax: Double { temp_max }
        // Formatted temperature string for display purposes
        var formattedTemperature: String {
            String(format: "%.1f°C", temp)
        }
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}
