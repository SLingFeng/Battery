//
//  RegionManager.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/17.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class RegionManager: NSObject, CLLocationManagerDelegate {
    let RegionRadius :CLLocationDistance = 500
    let kDateKey = "SDRegion"
    
    var dataArr :[RegionModel]?
    
    var managedContext: NSManagedObjectContext!

    
    public var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    //单例
    static let manager = RegionManager()

    override init() {
        super.init()
        managedContext = CoreDataManager().mangerContext

        dataArr = DataManager.getDataList(mc: managedContext)

//        for obj in dataArr! {
//            let d = obj.startTime?.timeIntervalSince1970
//print(d)
//            print(obj.identifier, obj.lat, obj.lon)
//        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public class func shareInstance() -> (_ :RegionManager) {
        return manager
    }
    //后台进入启动
    public func startRegion() {
        if dataArr?.count != 0 {
            for obj in dataArr! {
                self.regionObserve(model: obj)
            }
        }
    }
    //停止
    public func stopRegion() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
    
    func regionObserve(model : RegionModel) {
        if (CLLocationManager.locationServicesEnabled()) {
            
            // 定义一个CLLocationCoordinate2D作为区域的圆
            // 使用CLCircularRegion创建一个圆形区域，
            // 确定区域半径
            var radius :CLLocationDistance = RegionRadius
            let lc2d = CLLocationCoordinate2DMake(model.lat, model.lon)

            if (RegionRadius > locationManager.maximumRegionMonitoringDistance) {
                radius = locationManager.maximumRegionMonitoringDistance
            }
            let fkit = CLCircularRegion(center: lc2d, radius: radius, identifier: model.identifier!)

            locationManager.startMonitoring(for: fkit)
            locationManager.requestState(for: fkit)
        }else {
//            _ = UIAlertView(title: "提醒", message: "您的设备不支持定位", delegate: nil, cancelButtonTitle: "确定").show()
//            let ac = UIAlertController(title: "提醒", message: "您的设备不支持定位", preferredStyle: UIAlertControllerStyle.alert)
        }

    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lc = locations.last
        let lc2d = lc?.coordinate
//        print("\(lc2d?.latitude)\(lc2d?.longitude)")
        currentLocation = lc!
        if (lc != nil) {
            locationManager.stopUpdatingLocation()
//            guard
            let model = RegionModel(context: managedContext)
            
            
            let geo = CLGeocoder()
            var identifier :String?
            geo.reverseGeocodeLocation(lc!) { (placemarks, error) in
                let loction = placemarks?.first
                identifier = String(format: "%@%@%@%@%@", loction?.country ?? "", loction?.locality ?? "", loction?.subLocality ?? "", loction?.thoroughfare ?? "", loction?.subThoroughfare ?? "")

                model.lat = lc2d?.latitude ?? 0.0
                model.lon = lc2d?.longitude ?? 0.0
                model.identifier = identifier
                
                self.queryModel(model: model)
                self.regionObserve(model: model)
            }
            
        }
    }
    
    
    // 进入指定区域
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if dataArr?.count != 0 {
            let obj = dataArr?[0]
            obj?.startTime = NSDate()
            managedContext.refresh(obj!, mergeChanges: true)
            do {try managedContext.save()} catch {}
        }
    }
    // 离开指定区域
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if dataArr?.count != 0 {
            let obj = dataArr?[0]
            obj?.endTime = NSDate()
            managedContext.refresh(obj!, mergeChanges: true)
            do {try managedContext.save()} catch {}

        }
    }
    // 区域状态改变
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        if dataArr?.count != 0 {
//            let obj = dataArr?[0]
//            obj?.startTime = NSDate()
//            managedContext.refresh(obj!, mergeChanges: true)
//            do {try managedContext.save()} catch {}
//
//        }
    }
    
    //重复不保存
    func queryModel(model : RegionModel) {
        if dataArr?.count == 0 {
            DataManager.saveModel(mc: managedContext, model: model)
        }
        for obj in dataArr! {
            if obj.identifier == nil {return}

            let id = NSString(string: obj.identifier!)
            if (id.isEqual(to: model.identifier!)) {
                return
            }else {
                DataManager.saveModel(mc: managedContext, model: model)
            }
        }
    }
}

