//
//  BatteryManager.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/18.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
//检测电量
class BatteryManager: NSObject {
    
    public static let batteryManager = BatteryManager()
    
    public func checkAndMonitorBatteryLevel() {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        print(device.batteryLevel)
        
        if device.batteryState == UIDeviceBatteryState.charging {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeBatteryLevel), name: NSNotification.Name("UIDeviceBatteryLevelDidChangeNotification"), object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.charging), name: NSNotification.Name("UIDeviceBatteryStateDidChangeNotification"), object: nil)

        
    }
    
    @objc func charging() {
        if UIDevice.current.batteryState == UIDeviceBatteryState.charging {
            print("1")
            RegionManager.shareInstance().startRegion()

        }else if UIDevice.current.batteryState == UIDeviceBatteryState.unplugged {
            print("2")
            NotificationCenter.default.post(name: NSNotification.Name("stopCharging"), object: nil)
        }
    }
    
    @objc func didChangeBatteryLevel() {
        let device = UIDevice.current
        if device.batteryLevel >= 0.90 {
            NotificationCenter.default.post(name: NSNotification.Name("stopCharging"), object: nil)
            
        }
    }
}
