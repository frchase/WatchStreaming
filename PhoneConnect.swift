//
//  PhoneConnect.swift
//  cvAruco
//
//  Created by Chase Allen on 12/9/23.
//  Copyright © 2023 Dan Park. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchConnectivityDelegate: NSObject, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    static let shared = WatchConnectivityDelegate()

    // Handle the received message from the Watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Process the received data on the iPhone side
        print("Received message on iPhone: \(message)")

        if let data = message as? [String: Double] {
            // Post a notification to update the ContentView
            NotificationCenter.default.post(name: .receivedWatchData, object: nil, userInfo: ["data": data])
        }
    }
}

extension Notification.Name {
    static let receivedWatchData = Notification.Name("ReceivedWatchDataNotification")
}
