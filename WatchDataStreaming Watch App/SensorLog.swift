//
//  SensorLog.swift
//  WatchDataStreaming Watch App
//
//  Created by Chase Allen on 11/29/23.
//

import Foundation
import CoreMotion
import WatchConnectivity

class SensorLogManager: NSObject, ObservableObject {
    var motionManager: CMMotionManager?
    
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    var i = 0
    
    private var samplingFrequency = 30.0
    var timer = Timer()
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
    }
    
    var currentSensorData: [String: Any] {
        return [
            "accX": accX,
            "accY": accY,
            "accZ": accZ,
            "gyrX": gyrX,
            "gyrY": gyrY,
            "gyrZ": gyrZ
        ]
    }
    
    @objc private func update() {
        
        if let data = motionManager?.accelerometerData {
            self.accX = data.acceleration.x
            self.accY = data.acceleration.y
            self.accZ = data.acceleration.z
        }
        else {
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
        }
        
        if let data = motionManager?.deviceMotion {
            self.gyrX = data.rotationRate.x
            self.gyrY = data.rotationRate.y
            self.gyrZ = data.rotationRate.z
            
        }
        else {
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        sendDataToiPhone()
        //print("accelerometer: (\(self.accX), \(self.accY), \(self.accZ)), gyroscope: (\(self.gyrX), \(self.gyrY), \(self.gyrZ))")
    }
    
    func startUpdate(_ sampleFreq: Double) {
        if motionManager!.isDeviceMotionAvailable {
            motionManager?.startAccelerometerUpdates()
            motionManager?.startDeviceMotionUpdates()
        }
        
        self.samplingFrequency = sampleFreq
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / sampleFreq,
                           target: self,
                           selector: #selector(self.update),
                           userInfo: nil,
                           repeats: true)
    }
    
    func stopUpdate() {
        self.timer.invalidate()
        
        if motionManager!.isDeviceMotionActive {
            motionManager?.stopAccelerometerUpdates()
            motionManager?.stopGyroUpdates()
        }
    }
    
    private func sendDataToiPhone() {
        if WCSession.default.isReachable {
            i += 1
            WCSession.default.sendMessage(currentSensorData, replyHandler: nil, errorHandler: { error in
                print("Error sending message to iPhone: \(error.localizedDescription)")
            })
        }
        print(i)
    }
}
