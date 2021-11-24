//
//  AppCoordinator.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import UIKit

/// Protocol to define rules of creating coordinators for routing/navigation
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
