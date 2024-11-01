//
//  WeatherService.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 31.10.2024.
//

import Foundation

final class WeatherService {
    private var apiKey: String {
        return APIConstants.getAPIKey()
    }

    private let retryConfig: RetryConfiguration

    init(retryConfig: RetryConfiguration = .default) {
        self.retryConfig = retryConfig
    }

    private func fetchWithRetry<T>(
        attempt: Int = 1,
        task: @escaping () async throws -> T
    ) async throws -> T {
        do {
            return try await task()
        } catch {
            // Проверяем, нужно ли делать повторную попытку
            guard attempt < retryConfig.maxAttempts else {
                throw NetworkError.maxRetryReached
            }

            // Вычисляем задержку с экспоненциальным ростом
            let delay = min(
                retryConfig.initialDelay * pow(retryConfig.exponentialMultiplier, Double(attempt - 1)),
                retryConfig.maxDelay
            )

            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

            // Рекурсивно пытаемся снова
            return try await fetchWithRetry(attempt: attempt + 1, task: task)
        }
    }
}

extension WeatherService: WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {

        return try await fetchWithRetry { [weak self] in
            guard let self = self else { throw NetworkError.unknown(NSError()) }

            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            // Проверяем HTTP статус
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success
                case 500...599:
                    throw NetworkError.serverError(httpResponse.statusCode)
                default:
                    print("Unexpected status code: \(httpResponse.statusCode)")
                }
            }

            do {
                return try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        }
    }
}
