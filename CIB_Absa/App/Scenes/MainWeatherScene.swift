//
//  MainWeatherScene.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import UIKit
import Combine
import CoreLocation

class MainWeatherScene: UIViewController {

    // MARK: - Properties
    var viewModel: WeatherViewModel?
    private var storage: Set<AnyCancellable> = []

    // MARK: - Weather Views
    private lazy var currentWeatherView = DayWeatherView(frame: .zero)
    private lazy var weeklyWeatherView = WeeklyWeatherView(frame: .zero)

    // MARK: - Location Properties
    private var currentLocation: CLLocation? {
        didSet {
            fetchWeatherData()
        }
    }

    private lazy var locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()

        // Configure Location Manager
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0

        return locationManager
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupObservables()
        self.setupPrechecks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViews()
    }

    fileprivate func setupPrechecks() {
        guard let viewModel = viewModel else { return }
        viewModel.isJailBroken ? self.showAlert(of: .deviceIsRooted, isCancellable: false) : self.requestCurrentLocation()
    }
}

// MARK: - UI Configurations
extension MainWeatherScene {

    private func setupViews() {
        view.backgroundColor = .systemBackground
        [currentWeatherView, weeklyWeatherView].forEach { view.addSubview($0) }

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentWeatherView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),

            weeklyWeatherView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            weeklyWeatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weeklyWeatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weeklyWeatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showAlert(of type: AlertType, isCancellable: Bool = true) {
        let title, message: String

        switch type {
        case .deviceIsRooted:
            title = "rooted_device_error_title".localized()
            message = "rooted_device_error_message".localized()
        case .locationNotAuthorized:
            title = "location_authorized_error_title".localized()
            message = "location_authorized_error_message".localized()
        case .locationRequestFailed:
            title = "location_request_error_title".localized()
            message = "location_request_error_message".localized()
        case .weatherDataNotAvailable:
            title = "location_data_error_title".localized()
            message = "location_data_error_message".localized()
        }

        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if isCancellable {
            // Add Cancel Action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }

        // Present Alert Controller
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

// MARK: - Data Configurations
extension MainWeatherScene {
    private func setupObservables() {
        guard let viewModel = viewModel else { return }

        viewModel.showCurrentWeatherLoader.sink(receiveValue: {
            self.currentWeatherView.startWeatherIndicator(start: $0)
        }).store(in: &storage)

        viewModel.showWeeklyWeatherLoader.sink(receiveValue: {
            self.weeklyWeatherView.startWeatherIndicator(start: $0)
        }).store(in: &storage)

        viewModel.showWeatherDataError.sink { [weak self] _ in
            self?.showAlert(of: .weatherDataNotAvailable)
        }.store(in: &storage)

        viewModel.dailyWeatherData.sink { [weak self] completion in
            switch completion {
            case .failure:
                self?.showAlert(of: .weatherDataNotAvailable)
            default: return
            }
        } receiveValue: { [weak self] dailyData in
            self?.setupDailyWeather(with: dailyData)
        }.store(in: &storage)

        viewModel.weeklyWeatherData.sink { [weak self] completion in
            switch completion {
            case .failure:
                self?.showAlert(of: .weatherDataNotAvailable)
            default: return
            }
        } receiveValue: { [weak self] weeklyData in
            self?.weeklyWeatherView.dataSource = weeklyData.list
        }.store(in: &storage)
    }

    private func setupDailyWeather(with data: WeatherResponse) {
        let largeFont = UIFont.systemFont(ofSize: 70)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)

        DispatchQueue.main.async {
            self.currentWeatherView.locationLabel.text = "\(data.name), \(data.sys.country)"
            self.currentWeatherView.temperatureLabel.text = data.main.temp.toCelsius()
            self.currentWeatherView.weatherDescriptionLabel.text = data.weather.first?.description

            switch data.weather.first?.main {
            case .clear: self.currentWeatherView.weatherIcon.image = UIImage(systemName: "sun.max.fill", withConfiguration: configuration)
            case .clouds: self.currentWeatherView.weatherIcon.image = UIImage(systemName: "cloud.fill", withConfiguration: configuration)
            case .rain: self.currentWeatherView.weatherIcon.image = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: configuration)
            default: self.currentWeatherView.weatherIcon.image = UIImage(systemName: "sun.max.fill", withConfiguration: configuration)
            }
        }
    }
}

// MARK: - Location Configurations
extension MainWeatherScene {

    private func requestCurrentLocation() {
        // Configure Location Manager
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Request Current Location
            locationManager.requestLocation()
        default:
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func fetchWeatherData() {
        guard
            let viewModel = self.viewModel,
            let location = currentLocation
        else { return }

        // Get Coordinates
        let coordinates = Coordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)

        // Retrieve weather data
        viewModel.getCurrentWeatherData(at: coordinates)
        viewModel.getWeeklyWeatherData(at: coordinates)
    }
}

// MARK: - Location Delegate
extension MainWeatherScene: CLLocationManagerDelegate {

    // MARK: - Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Request Location
            manager.requestLocation()
        case .denied, .restricted:
            // Alert User
            showAlert(of: .locationNotAuthorized)
        default:
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude)
        }
    }

    // MARK: - Location Updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update Current Location
            currentLocation = location

            // Reset Delegate
            manager.delegate = nil

            // Stop Location Manager
            manager.stopUpdatingLocation()

        } else {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude)
        }
    }

    // MARK: - Location Fetch Failed
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if currentLocation == nil {
            // Fall Back to Default Location
            currentLocation = CLLocation(latitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude)
        }

        // Alert User
        showAlert(of: .locationRequestFailed)
    }
}
