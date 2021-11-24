//
//  WeatherCoordinator.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import UIKit

class WeatherCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// Initial coordinator loaded
    func start() {
        let scene = MainWeatherScene()
        scene.viewModel = WeatherViewModel(apiClient: APIClient())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(scene, animated: true)
    }
}
