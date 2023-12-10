//
//  WatchConnect.swift
//  WatchDataStreaming Watch App
//
//  Created by Chase Allen on 11/29/23.
//

import Foundation
import WatchConnectivity

class WatchConnectivityDelegate: NSObject, ObservableObject, WCSessionDelegate {
    
    static let shared = WatchConnectivityDelegate()

    // Handle the received message from the iPhone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Process the received data on the Watch side if needed
        print("Received message on Watch: \(message)")
    }

    // Add other necessary WCSessionDelegate methods if needed
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
}

