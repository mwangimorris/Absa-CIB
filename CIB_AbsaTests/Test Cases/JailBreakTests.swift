//
//  JailBreakTests.swift
//  CIB_AbsaTests
//
//  Created by Morris Mwangi on 25/11/2021.
//

import XCTest
@testable import CIB_Absa

class JailBreakTests: XCTestCase {

    // MARK: - Properties
    var jailBreakChecker: JailBreakCheck!

    override func setUpWithError() throws {
        jailBreakChecker = JailBreakCheck()
    }

    override func tearDownWithError() throws {
        jailBreakChecker = nil
    }

    /// Check device is not a simulator
    func testDeviceIsNotSimulator() {
        XCTAssert(!jailBreakChecker.isSimulator)
    }

    /// Check device is not rooted
    func testDeviceIsNotRooted() {
        XCTAssert(!jailBreakChecker.isJailBroken())
    }

    /// Check device does not contain suspicious paths
    func testDeviceNotContainSuspiciousPaths() {
        XCTAssert(!jailBreakChecker.containsSuspiciousSystemPaths())
    }

    /// Check device does not contain suspicious apps
    func testDeviceNotContainSuspiciousApps() {
        XCTAssert(!jailBreakChecker.containsSuspiciousApps())
    }

    /// Check device cannot write or edit system files
    func testDeviceCannotWriteToSystemFiles() {
        XCTAssert(!jailBreakChecker.canWriteSystemFiles())
    }

    /// Check device does not contain cydia
    func testDeviceHasNoCydiaInstalled() {
        XCTAssert(!jailBreakChecker.hasCydiaInstalled())
    }

    /// Test that the suspicious apps list is not altered
    func testSuspiciousApps() {
        XCTAssertNotNil(jailBreakChecker.suspiciousAppsPathToCheck)
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.cydiaApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.blackRainApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.fakeCarrierApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.icyApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.mxTubeApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.intelliScreenApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.rockApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.sbSettingsApp.rawValue))
        XCTAssert(jailBreakChecker.suspiciousAppsPathToCheck.contains(SuspiciousApps.winterBoardApp.rawValue))
    }

    /// Test that the suspicious apps list is not altered
    func testSuspiciousPaths() {
        XCTAssertNotNil(jailBreakChecker.suspiciousSystemPathsToCheck)
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.liveClock.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.veency.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.apt.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.aptPath.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.cydiaPath.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.sbSettings.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.stash.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.cydiaLog.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.launchDaemonsBot.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.launchDaemonsCydia.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.binSshd.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.sftpServer.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.sbinSshd.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.etcApt.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.bash.rawValue))
        XCTAssert(jailBreakChecker.suspiciousSystemPathsToCheck.contains(SuspiciousPaths.mobileSubstrate.rawValue))
    }
}
