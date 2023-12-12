//
//  ContentView.swift
//  Kalman filter Testing
//
//  Created by Andy Dong on 11/1/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject private var kalman = KalmanFilter(initialState: 1.0, initialErrorCovariance: 2.0)
    var body: some View {
        VStack {
            Button {
                kalman.testKalmanFilter()
            } label: {
                Text("test")
            }
        }
    }
}

#Preview {
    ContentView()
}

