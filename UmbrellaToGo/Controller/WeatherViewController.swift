//
//  WeatherViewController.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 31.10.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {

    // MARK: - Dependencies
    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherServiceProtocol

    // MARK: - Properties
    private let debugLocation = CLLocation(latitude: 55.7558, longitude: 37.6173) // Москва

    // MARK: - UI Elements
    private let mainView = MainView()
    private let loader = LoaderView()
    private let gradientLayer = GradientLayer(colors: [.systemTeal, .systemMint, .systemIndigo], angle: 30, opacity: 0.75)

    init(locationService: LocationServiceProtocol = LocationService(),
         weatherService: WeatherServiceProtocol = WeatherService(retryConfig: .default)) {
        self.locationService = locationService
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationService()

//#if targetEnvironment(simulator)
//        fetchWeatherForLocation(debugLocation)
//#endif
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Обновляем размер градиента при изменении размеров view
        gradientLayer.frame = view.bounds
    }
}

// MARK: - UI Methods
extension WeatherViewController {
    private func setupUI() {
        mainView.setup()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)

        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        view.addSubview(loader)

        NSLayoutConstraint.activate([
            mainView.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            mainView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.6),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        setupGradient()
    }

    private func setupGradient() {
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func updateUI(with weather: WeatherResponse) {
        mainView.locationLabel.attributedText = NSAttributedString(
            string: weather.name,
            attributes: TextStyle.locationTitle
        )

        let tempString = String(format: "%.1f°C", weather.main.temp)
        let tempAttrs = NSMutableAttributedString(
            string: tempString,
            attributes: TextStyle.temperature
        )
        mainView.temperatureLabel.attributedText = tempAttrs

        // Feels Like
        let feelsLikeString = String(format: "Feels like %.1f°C", weather.main.feelsLike)
        mainView.feelsLikeLabel.attributedText = NSAttributedString(
            string: feelsLikeString,
            attributes: TextStyle.feelsLike
        )

        // Conditions
        let conditions = weather.weather.map { $0.description.capitalized }.joined(separator: ", ")
        mainView.conditionsLabel.attributedText = NSAttributedString(
            string: conditions,
            attributes: TextStyle.conditions
        )

        updateUmbrellaAdvice(shouldTakeUmbrella: weather.hasRain)
        mainView.subviews.forEach {
            ($0 as? UILabel)?.textAlignment = .center
        }
    }

    private func updateUmbrellaAdvice(shouldTakeUmbrella: Bool) {
        let umbrellaAttrs = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            NSAttributedString.Key.foregroundColor: shouldTakeUmbrella ? UIColor.white : UIColor.systemOrange
        ]

        let text = shouldTakeUmbrella ? "Grab an umbrella" : "Don't take an umbrella"
        let symbolName = shouldTakeUmbrella ? "umbrella.fill" : "rainbow"
        let umbrellaString = NSMutableAttributedString(
            string: text,
            attributes: umbrellaAttrs
        )

        let symbolConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 22, weight: .semibold),
            scale: .large
        )

        var image = UIImage(systemName: symbolName)?.withConfiguration(symbolConfig)

        if shouldTakeUmbrella {
            mainView.imageView.tintColor = .systemPink
        } else {
            image = image?.withRenderingMode(.alwaysOriginal)
        }
        mainView.imageView.image = image
        mainView.umbrellaAdviceLabel.attributedText = umbrellaString
    }
}

// MARK: - Error Handling
extension WeatherViewController {
    private func handleLocationError() {
        mainView.locationLabel.attributedText = NSAttributedString(string: "No access to geolocation")

        let alert = UIAlertController(
            title: "Location Access",
            message: "Access to your location is required for the app to work. Please enable it in the settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Retry",
            style: .default,
            handler: { [weak self] _ in
                guard let location = self?.locationService.location else {
                    self?.locationService.startUpdatingLocation()
                    return
                }
                self?.fetchWeatherForLocation(location)
            }
        ))
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - Data Receiving
extension WeatherViewController {
    private func fetchWeatherForLocation(_ location: CLLocation) {
        Task {
            do {
                defer {
                    loader.stopLoading()
                }

                loader.startLoading()
                let weather = try await weatherService.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                await MainActor.run {
                    updateUI(with: weather)
                }
            } catch NetworkError.maxRetryReached {
                await MainActor.run {
                    showError("Failed to retrieve weather data after several attempts")
                }
            } catch NetworkError.serverError(let code) {
                await MainActor.run {
                    showError("Server error: \(code)")
                }
            } catch {
                await MainActor.run {
                    showError("An error occurred while receiving data")
                }
            }
        }
    }
}

// MARK: - Location Setting
extension WeatherViewController {
    private func setupLocationService() {
        locationService.delegate = self

        switch locationService.authorizationStatus {

        case .notDetermined:
            locationService.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            locationService.startUpdatingLocation()

        case .denied, .restricted:
            handleLocationError()

        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: LocationServiceDelegate {
    func locationService(_ service: LocationServiceProtocol, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        service.stopUpdatingLocation()
        fetchWeatherForLocation(location)
    }

    func locationService(_ service: LocationServiceProtocol, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                handleLocationError()
            case .locationUnknown:
#if targetEnvironment(simulator)
                fetchWeatherForLocation(debugLocation)
#endif
                print("WeatherViewController: Location unknown")
            default:
                handleLocationError()
            }
        } else {
            handleLocationError()
        }
    }

    func locationServiceDidChangeAuthorization(_ service: LocationServiceProtocol) {
        switch service.authorizationStatus {

        case .authorizedWhenInUse, .authorizedAlways:
            service.startUpdatingLocation()

        case .denied, .restricted:
            handleLocationError()

        default:
            break
        }
    }
}
