//
//  ContentView.swift
//  WatchDataStreaming Watch App
//
//  Created by Chase Allen on 11/29/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var logStarting = false
    @ObservedObject var sensorLogger = SensorLogManager()

    var body: some View {
        /// Activates the session for sending the data to iPhone and the display of the data on watch
        VStack {
            Button {
                self.logStarting.toggle()

                if self.logStarting {
                    self.sensorLogger.startUpdate(30.0)
                } else {
                    self.sensorLogger.stopUpdate()
                }
            } label: {
                Text(self.logStarting ? "Pause" : "Start")
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                    .background(self.logStarting ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        /// Displays Gyroscope and Accelerometer data
        VStack {
            DataDisplayView()
        }
        .onAppear {
            // On appear of this view check if the delegate is supported
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = WatchConnectivityDelegate.shared
                session.activate()
                // Send initial data to iPhone when the view appears
            }
        }
    }
}

#Preview {
    ContentView()
}
