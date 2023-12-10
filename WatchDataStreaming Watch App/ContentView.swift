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
        VStack {
            Button(action: {
                self.logStarting.toggle()

                if self.logStarting {
                    self.sensorLogger.startUpdate(30.0)
                } else {
                    self.sensorLogger.stopUpdate()
                }
                self.sendDataToiPhone()
            }) {
                Text(self.logStarting ? "Pause" : "Start")
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                    .background(self.logStarting ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        VStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.blue)
                    Text("Accelerometer")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                HStack {
                    Text(String(format: "%.2f", self.sensorLogger.accX))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.accY))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.accZ))
                }.padding(.horizontal)
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.blue)
                    Text("Gyroscope")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                HStack {
                    Text(String(format: "%.2f", self.sensorLogger.gyrX))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.gyrY))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.gyrZ))
                }.padding(.horizontal)
            }
        }
        .onAppear {
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = WatchConnectivityDelegate.shared
                session.activate()
                // Send initial data to iPhone when the view appears
            }
        }
    }
    
    private func sendDataToiPhone() {
        if WCSession.default.isReachable {
            let sensorData = [
                "accX": self.sensorLogger.accX,
                "accY": self.sensorLogger.accY,
                "accZ": self.sensorLogger.accZ,
                "gyrX": self.sensorLogger.gyrX,
                "gyrY": self.sensorLogger.gyrY,
                "gyrZ": self.sensorLogger.gyrZ,
            ]

            WCSession.default.sendMessage(sensorData, replyHandler: nil, errorHandler: { error in
                print("Error sending message to iPhone: \(error.localizedDescription)")
            })
        }
    }
}

#Preview {
    ContentView()
}
