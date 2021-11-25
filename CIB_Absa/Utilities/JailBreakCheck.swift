//
//  JailBreakCheck.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 25/11/2021.
//

import UIKit

/// List of suspicious Apps. Configure remotely and always add new suspected apps
enum SuspiciousApps: String, CaseIterable {
    case cydiaApp = "/Applications/Cydia.app"
    case blackRainApp = "/Applications/blackra1n.app"
    case fakeCarrierApp = "/Applications/FakeCarrier.app"
    case icyApp = "/Applications/Icy.app"
    case intelliScreenApp = "/Applications/IntelliScreen.app"
    case mxTubeApp = "/Applications/MxTube.app"
    case rockApp = "/Applications/RockApp.app"
    case sbSettingsApp = "/Applications/SBSettings.app"
    case winterBoardApp = "/Applications/WinterBoard.app"
}

/// List of suspicious paths. Configure remotely and always add new suspected paths
enum SuspiciousPaths: String, CaseIterable {
    case liveClock = "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist"
    case veency = "/Library/MobileSubstrate/DynamicLibraries/Veency.plist"
    case apt = "/private/var/lib/apt"
    case aptPath = "/private/var/lib/apt/"
    case cydiaPath = "/private/var/lib/cydia"
    case sbSettings = "/private/var/mobile/Library/SBSettings/Themes"
    case stash = "/private/var/stash"
    case cydiaLog = "/private/var/tmp/cydia.log"
    case launchDaemonsBot = "/System/Library/LaunchDaemons/com.ikey.bbot.plist"
    case launchDaemonsCydia = "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist"
    case binSshd = "/usr/bin/sshd"
    case sftpServer = "/usr/libexec/sftp-server"
    case sbinSshd = "/usr/sbin/sshd"
    case etcApt = "/etc/apt"
    case bash = "/bin/bash"
    case mobileSubstrate = "/Library/MobileSubstrate/MobileSubstrate.dylib"
}

/// Jail break rules
protocol Breakable {
    var isSimulator: Bool { get }
    func isJailBroken() -> Bool
    func hasCydiaInstalled() -> Bool
    func containsSuspiciousApps() -> Bool
    func containsSuspiciousSystemPaths() -> Bool
    func canWriteSystemFiles() -> Bool
}

struct JailBreakCheck: Breakable {

    var isSimulator: Bool {
        // Check if device is simulator
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }

    var suspiciousAppsPathToCheck: [String] {
        return SuspiciousApps.allCases.map { $0.rawValue }
    }

    var suspiciousSystemPathsToCheck: [String] {
        return SuspiciousPaths.allCases.map { $0.rawValue }
    }

    func isJailBroken() -> Bool {
        if self.isSimulator { return false }
        if self.hasCydiaInstalled() { return true }
        if self.containsSuspiciousApps() { return true }
        if self.containsSuspiciousSystemPaths() { return true }
        return self.canWriteSystemFiles()
    }

    func hasCydiaInstalled() -> Bool {
        if let cydiaUrlScheme = URL(string: "cydia://") {
            return UIApplication.shared.canOpenURL(cydiaUrlScheme)
        }

        return false
    }

    func containsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }

    func containsSuspiciousSystemPaths() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }

    func canWriteSystemFiles() -> Bool {
        // Check if random potential jailbreak files can be written into the app
        let path = "/private/" + UUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
}
