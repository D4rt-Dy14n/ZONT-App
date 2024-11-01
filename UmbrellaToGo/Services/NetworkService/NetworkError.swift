//
//  NetworkError.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case maxRetryReached
    case unknown(Error)
}
