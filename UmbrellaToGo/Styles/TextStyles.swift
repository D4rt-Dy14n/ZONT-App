//
//  TextStyles.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 31.10.2024.
//

import UIKit

struct TextStyle {
    static let locationTitle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 24, weight: .bold),
        .foregroundColor: UIColor.white,
    ]

    static let temperature: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 36, weight: .medium),
        .foregroundColor: UIColor.white
    ]

    static let feelsLike: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 18, weight: .regular),
        .foregroundColor: UIColor.white.withAlphaComponent(0.8)
    ]

    static let conditions: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20, weight: .medium),
        .foregroundColor: UIColor.white
    ]

    static let umbrellaAdvice: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
        .foregroundColor: UIColor.white
    ]
}
