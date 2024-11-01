//
//  GradientLayer.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import UIKit

final class GradientLayer: CAGradientLayer {

    // MARK: - Initialization
    init(colors: [UIColor], angle: CGFloat = 0, opacity: Float = 1.0) {
        super.init()
        configure(colors: colors, angle: angle, opacity: opacity)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Configuration
    private func configure(colors: [UIColor], angle: CGFloat, opacity: Float) {
        self.colors = colors.map { $0.cgColor }
        self.opacity = opacity

        // Конвертируем угол из градусов в радианы
        let angleInRadian = angle * CGFloat.pi / 180

        // Вычисляем точки начала и конца градиента
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(
            x: cos(angleInRadian),
            y: sin(angleInRadian)
        )
    }

    // MARK: - Public Methods

    func updateColors(_ colors: [UIColor]) {
        self.colors = colors.map { $0.cgColor }
    }

    func updateAngle(_ angle: CGFloat) {
        let angleInRadian = angle * CGFloat.pi / 180

        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(
            x: cos(angleInRadian),
            y: sin(angleInRadian)
        )
    }

    func updateOpacity(_ opacity: Float) {
        self.opacity = opacity
    }
}
