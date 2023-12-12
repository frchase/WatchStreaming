//
//  DataDisplayView.swift
//  WatchDataStreaming Watch App
//
//  Created by Chase Allen on 12/12/23.
//

import SwiftUI

struct DataDisplayView: View {
    @ObservedObject var sensorLogger = SensorLogManager()
    var body: some View {
        
        /// Display updated Accelerometer data as it streams
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
        
        /// Display updated Gyroscope data as it streams
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
}

#Preview {
    DataDisplayView()
}
