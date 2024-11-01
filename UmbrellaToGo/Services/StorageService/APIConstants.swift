//
//  APIConstants.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation

enum APIConstants {
    static let serviceName = "com.UmbrellaToGo"
    static let accountName = "openweather"
    static let defaultAPIKey = "5cd9cf3b9da9a8da9baa90badbfc00be"

    static func setupAPIKey() {
        do {
            try KeychainService.shared.save(defaultAPIKey,
                                            for: accountName,
                                            service: serviceName)
        } catch KeychainError.duplicateEntry {
            // Ключ уже сохранен
            print("API key already stored")
        } catch {
            print("Error storing API key: \(error)")
        }
    }

    static func getAPIKey() -> String {
        do {
            return try KeychainService.shared.getPassword(
                for: accountName,
                service: serviceName
            )
        } catch {
            print("Error retrieving API key: \(error)")
            return defaultAPIKey
        }
    }
}
