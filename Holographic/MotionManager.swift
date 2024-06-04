//
//  MotionManager.swift
//  Holographic
//
//  Created by Trevor Stacy on 6/4/24.
//

import Foundation
import SwiftUI
import CoreMotion

@Observable class MotionManager {
    private var motionManager: CMMotionManager
    var pitch: Double = 0.0
    var roll: Double = 0.0
    var yaw: Double = 0.0
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        self.motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data, error == nil else { return }
            self?.pitch = data.attitude.pitch
            self?.roll = data.attitude.roll
            self?.yaw = data.attitude.yaw
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
