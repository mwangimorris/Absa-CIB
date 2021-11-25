//
//  Configurations.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import UIKit

// MARK: - Alert Types
enum AlertType {
    case deviceIsRooted
    case locationNotAuthorized
    case locationRequestFailed
    case weatherDataNotAvailable
}

// MARK: - Set Default Location
struct DefaultLocation {
    // Currently set to Nairobi,Kenya
    static let latitude: Double = 1.2921
    static let longitude: Double = 36.8219
}
