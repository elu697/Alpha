//
//  BeaconSearchView.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/08/23.
//

import SwiftUI

struct BeaconSearchView: View {
    @StateObject private var viewModel: BeaconSearchViewModel = .init()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Filters")) {
                        TextField("UUID", text: $viewModel.uuidText)
                            .keyboardType(.default)
                        TextField("Major", text: $viewModel.majorText)
                            .keyboardType(.numberPad)
                        TextField("Minor", text: $viewModel.minorText)
                            .keyboardType(.numberPad)
                        HStack {
                            if viewModel.isScanning {
                                Button("Stop Scanning") {
                                    viewModel.stopScanning()
                                }
                                .foregroundColor(.red)
                            } else {
                                Button("Apply Filters & Start Scanning") {
                                    viewModel.startScanning()
                                }
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    Section(header: Text("Beacons")) {
                        List(viewModel.beacons, id: \.uuid) { beacon in
                            VStack(alignment: .leading) {
                                Text("UUID: \(beacon.uuid.uuidString)")
                                Text("Major: \(beacon.major), Minor: \(beacon.minor)")
                                Text("Accuracy: \(String(format: "%.2f", beacon.accuracy))")
                                Text("Distance: \(String(format: "%d", beacon.proximity.rawValue)) meters")
                                Text("RSSI: \(beacon.rssi) dBm")
                            }
                        }
                        if viewModel.isScanning {
                            HStack {
                                Spacer()
                                ProgressView("Scanning...\(viewModel.changeCount)")
                                Spacer()
                            }
                        }
                    }
                }
                .scrollDismissesKeyboard(.automatic)

                Text(viewModel.statusMessage)
                    .padding()
                    .foregroundColor(.gray)
            }
            .navigationTitle("iBeacon Scanner")
        }
    }
}
