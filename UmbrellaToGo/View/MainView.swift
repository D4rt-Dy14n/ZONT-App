//
//  MainView.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 01.11.2024.
//

import UIKit

final class MainView: UIView {
    private enum Constants {
        static let locationAttributes = NSAttributedString(
            string: "—",
            attributes: TextStyle.locationTitle
        )
        static let tempAttributes = NSAttributedString(
            string: "—",
            attributes: TextStyle.temperature
        )
        static let feelsLikeAttributes = NSAttributedString(
            string: "—",
            attributes: TextStyle.feelsLike
        )
        static let conditionAttributes = NSAttributedString(
            string: "—",
            attributes: TextStyle.conditions
        )
        static let umbrellaAdviceAttributes = NSAttributedString(
            string: "Data loading",
            attributes: TextStyle.umbrellaAdvice
        )
    }

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let locationLabel = UILabel()
    let temperatureLabel = UILabel()
    let feelsLikeLabel = UILabel()
    let conditionsLabel = UILabel()
    let umbrellaAdviceLabel = UILabel()
    let imageView = UIImageView()

    func setup() {
        addSubview(stackView)
        setLoadingState()
        [locationLabel, temperatureLabel, feelsLikeLabel, conditionsLabel, umbrellaAdviceLabel].forEach { label in
            label.textAlignment = .center
            label.numberOfLines = 0
            label.setContentHuggingPriority(.required, for: .vertical)
            stackView.addArrangedSubview(label)
        }
        
        stackView.insertArrangedSubview(imageView, at: 4)
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setLoadingState() {
        locationLabel.attributedText = Constants.locationAttributes
        temperatureLabel.attributedText = Constants.tempAttributes
        feelsLikeLabel.attributedText = Constants.feelsLikeAttributes
        conditionsLabel.attributedText = Constants.conditionAttributes
        umbrellaAdviceLabel.attributedText = Constants.umbrellaAdviceAttributes
    }
}
