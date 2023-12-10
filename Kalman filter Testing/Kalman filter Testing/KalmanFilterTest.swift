//
//  KalmanFilterTest.swift
//  Kalman filter Testing
//
//  Created by Andy Dong on 11/22/23.
//

import Foundation
import SwiftUI

class KalmanFilter: ObservableObject {
    let initialMeasurementError = 1.0
    let processNoise = 0.01
    var state: Double
    var errorCovariance: Double
    
    init(initialState: Double, initialErrorCovariance: Double) {
        state = initialState
        errorCovariance = initialErrorCovariance
    }
    
    func update(measurement: Double) {
        
        let predictedState = state
        let predictedErrorCovariance = errorCovariance + processNoise
        
        // Correction step
        let kalmanGain = predictedErrorCovariance / (predictedErrorCovariance + initialMeasurementError)
        state = predictedState + kalmanGain * (measurement - predictedState)
        errorCovariance = (1 - kalmanGain) * predictedErrorCovariance
    }
    
    func processAccelerometerDataWithKalmanFilter(dataArray: inout [(x: Double, y: Double, z: Double)], newData: (x: Double, y: Double, z: Double)) {
        // Apply Kalman filter to the latest accelerometer data
        if dataArray.isEmpty{
            dataArray.append(newData)
        }else{
            let dataarraylast = dataArray[dataArray.count-1]
            
            let kalmanFilterX = KalmanFilter(initialState: dataarraylast.0, initialErrorCovariance: initialMeasurementError)
            kalmanFilterX.update(measurement: newData.x)
            
            let kalmanFilterY = KalmanFilter(initialState: dataarraylast.1, initialErrorCovariance: initialMeasurementError)
            kalmanFilterY.update(measurement: newData.y)
            
            let kalmanFilterZ = KalmanFilter(initialState: dataarraylast.2, initialErrorCovariance: initialMeasurementError)
            kalmanFilterZ.update(measurement: newData.z)
            
            print("Filtered Accelerometer Data: X: \(kalmanFilterX.state), Y: \(kalmanFilterY.state), Z: \(kalmanFilterZ.state)")
            dataArray.append((kalmanFilterX.state,kalmanFilterY.state,kalmanFilterZ.state))
        }
    }
    var opencvDataArray: [(x: Double, y: Double, z: Double)] = []
    
    func testKalmanFilter() {
        let start: Double = 0.0
            let end: Double = 10.0
            let steps: Int = 10
            let stepSize: Double = (end - start) / Double(steps - 1)
            var linearDataArray: [(x: Double, y: Double, z: Double)] = []
            for i in 0..<steps {
                // Simulate a linear trajectory with some noise
                let noise: Double = 0.1 // Adjust this as needed
                let x_val = start + stepSize * Double(i) + Double.random(in: -noise...noise)
                let y_val = 0.0 + Double.random(in: -noise...noise)
                let z_val = 0.0 + Double.random(in: -noise...noise)
                let newData = (x: x_val, y: y_val, z: z_val)
                processAccelerometerDataWithKalmanFilter(dataArray: &linearDataArray, newData: newData)
            }
            print("Processed Linear Trajectory Data Array: \(linearDataArray)")
        }
}
