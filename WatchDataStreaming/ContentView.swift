//
//  ContentView.swift
//  WatchDataStreaming
//
//  Created by Chase Allen on 11/29/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var receivedData: [String: Double] = [:]
    var body: some View {
        VStack {
            // Display the received data on the iPhone's ContentView
            Text("Received Data:")
                .font(.headline)
                .padding()
            
            if !receivedData.isEmpty {
                VStack {
                    Text("Accelerometer:")
                        .font(.subheadline)
                    Text("X: \(receivedData["accX"] ?? 0.0)")
                    Text("Y: \(receivedData["accY"] ?? 0.0)")
                    Text("Z: \(receivedData["accZ"] ?? 0.0)")
                }
                .padding()
                
                VStack {
                    Text("Gyroscope:")
                        .font(.subheadline)
                    Text("X: \(receivedData["gyrX"] ?? 0.0)")
                    Text("Y: \(receivedData["gyrY"] ?? 0.0)")
                    Text("Z: \(receivedData["gyrZ"] ?? 0.0)")
                }
                .padding()
            } else {
                Text("No data received yet.")
            }
        } .onAppear {
            // Set up WatchConnectivity to receive data from the Watch app
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = WatchConnectivityDelegate.shared
                session.activate()
                print("supported")
                
                NotificationCenter.default.addObserver(forName: .receivedWatchData, object: nil, queue: .main) { notification in
                    if let data = notification.userInfo?["data"] as? [String: Double] {
                        // Update the received data on the ContentView
                        receivedData = data
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
