//
//  RetryConfiguration.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import Foundation

struct RetryConfiguration {
    let maxAttempts: Int
    let initialDelay: TimeInterval
    let maxDelay: TimeInterval
    let exponentialMultiplier: Double

    static let `default` = RetryConfiguration(
        maxAttempts: 3,
        initialDelay: 1.0,
        maxDelay: 10.0,
        exponentialMultiplier: 2.0
    )
}
