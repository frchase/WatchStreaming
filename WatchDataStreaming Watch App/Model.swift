//
//  Model.swift
//  WatchDataStreaming Watch App
//
//  Created by Chase Allen on 11/29/23.
//

import Foundation

struct SensorData: Codable {
    let accX: Double
    let accY: Double
    let accZ: Double
    let gryX: Double
    let gryY: Double
    let gryZ: Double
}
