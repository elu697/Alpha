//
//  BeaconSearchViewModel.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/08/23.
//

import CoreLocation
import SwiftUI

@MainActor
class BeaconSearchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var beacons: [CLBeacon] = []
    @Published var uuidText: String = "41462998-6CEB-4511-9D46-1F7E27AA6572"
    @Published var majorText: String = ""
    @Published var minorText: String = ""
    @Published var statusMessage: String = "Scanning not started."
    @Published var isScanning = false
    @Published var changeCount: Int = 0

    private var filterUUID: UUID?
    private var filterMajor: NSNumber?
    private var filterMinor: NSNumber?
    private var beaconRegion: CLBeaconRegion?


    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self

        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startScanning() {
        stopScanning()
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            locationManager.requestLocation()
            //            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            statusMessage = "Location permission is required."
            return
        }

        guard let uuid = UUID(uuidString: uuidText) else {
            statusMessage = "Invalid UUID"
            return
        }

        filterUUID = uuid
        filterMajor = majorText.isEmpty ? nil : NSNumber(value: Int(majorText) ?? 0)
        filterMinor = minorText.isEmpty ? nil : NSNumber(value: Int(minorText) ?? 0)

        beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "MyBeaconRegion")
        if let beaconRegion = beaconRegion {
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
        }

        statusMessage = "Scanning for beacons..."
        isScanning = true
        changeCount = 0
    }

    func stopScanning() {
        if let beaconRegion = beaconRegion {
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: filterUUID!))
        }

        statusMessage = "Scanning stopped."
        isScanning = false
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.beacons = beacons.filter { beacon in
                (self.filterMajor == nil || beacon.major == self.filterMajor) &&
                    (self.filterMinor == nil || beacon.minor == self.filterMinor)
            }

            if self.beacons.isEmpty {
                self.statusMessage = "No beacons found."
            } else {
                self.statusMessage = "Beacons found."
            }
            self.changeCount += 1
        }
    }

    private func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLBeaconRegion) {
        if region == beaconRegion {
            DispatchQueue.main.async {
                self.statusMessage = "Entered beacon region! ✅"
            }
        }
    }

    private func locationManager(_ manager: CLLocationManager, didExitRegion region: CLBeaconRegion) {
        if region == beaconRegion {
            DispatchQueue.main.async {
                self.statusMessage = "Exited beacon region! ❌"
            }
        }
    }
}
