//
//  KalmanFilter.swift
//  cvAruco
//
//  Created by Chase Allen on 12/9/23.
//  Copyright © 2023 Dan Park. All rights reserved.
//

import Foundation
import SwiftUI
import WatchConnectivity

class KalmanFilter: ObservableObject {
    let initialMeasurementError = 1.0
    let processNoise = 0.5
    var state: SIMD3<Double> = SIMD3<Double>(0.0,0.0,0.0)
    var errorCovariance: SIMD3<Double>
    private var receivedData: [String: Double] = [:]
    
    init(initialState: SIMD3<Double>, initialErrorCovariance: SIMD3<Double>) {
        state = initialState
        errorCovariance = initialErrorCovariance
    }
    
    func update(measurement: SIMD3<Double>) {
        
        let predictedState = state
        let predictedErrorCovariance = errorCovariance + processNoise
        
        // Correction step
        let kalmanGain = predictedErrorCovariance / (predictedErrorCovariance + initialMeasurementError)
        state = predictedState + kalmanGain * (measurement - predictedState)
        errorCovariance = (1.0 - kalmanGain) * predictedErrorCovariance
    }
    
    func processAccelerometerDataWithKalmanFilter(newData: SIMD3<Double>)
    {    self.update(measurement: newData)     }
    
    func testKalmanFilter() {
        let start: Double = 0.0
        let end: Double = 10.0
        let steps: Int = 500
        let stepSize: Double = (end - start) / Double(steps - 1)
        var linearDataArray: [(x: Double, y: Double, z: Double)] = []
        for i in 0..<steps {
            let expect = start + stepSize * Double(i)
            // Simulate a linear trajectory with some noise
            let x_val = expect + Double.random(in: -processNoise...processNoise)
            let y_val = expect + Double.random(in: -processNoise...processNoise)
            let z_val = expect + Double.random(in: -processNoise...processNoise)
            let newData = (x: x_val, y: y_val, z: z_val)
            processAccelerometerDataWithKalmanFilter(newData: SIMD3(x_val, y_val, z_val))
            print("Expected Data: X:\(expect), Y:\(expect), Z:\(expect)")
            print("Input    Data: X:\(newData.x), Y:\(newData.y), Z:\(newData.z)")
            print("Filtered Data: X:\(state.x), Y:\(state.y), Z:\(state.z)")
            print("Error        : X:\(expect - state.x), Y:\(expect - state.y), Z:\(expect - state.z)")
            print()
        }
    }
    
    
    func watchData() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = WatchConnectivityDelegate.shared
            session.activate()
            print("supported")
            
            NotificationCenter.default.addObserver(forName: .receivedWatchData, object: nil, queue: .main) { notification in
                if let data = notification.userInfo?["data"] as? [String: Double] {
                    // Update the received data on the ContentView
                    self.receivedData = data
                }
            }
        }
    }
}
