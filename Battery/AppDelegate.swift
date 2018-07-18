//
//  AppDelegate.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/17.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var backgroundTaskIdentifier = UIBackgroundTaskIdentifier()
    var timer : Timer? = nil
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        RegionManager.shareInstance().startRegion()
        
        BatteryManager.batteryManager.checkAndMonitorBatteryLevel()
        
        self.timer = Timer(timeInterval: 1.0, repeats: true, block: { (t) in
            self.endBackgroundTask()
        })
        if (launchOptions?[UIApplicationLaunchOptionsKey.location] != nil) {
            
        }
        
//        UNNotificationSettings()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            
        }
        
        backgroundTaskIdentifier = application.beginBackgroundTask(expirationHandler: {
            self.endBackgroundTask()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.endBackgroundTask), name: NSNotification.Name("NinetyPercent"), object: nil)
        
        return true
    }
    
    @objc func endBackgroundTask() {
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
        }
        
//        self.timer?.invalidate()
//        // 标记指定的后台任务完成
//        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
//        // 销毁后台任务标识符
//        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // 使用这个方法来释放公共的资源、存储用户数据、停止我们定义的定时器（timers）、并且存储在程序终止前的相关信息。
        
        // 如果，我们的应用程序提供了后台执行的方法，那么，在程序退出时，这个方法将代替applicationWillTerminate方法的执行。
        
        // 标记一个长时间运行的后台任务将开始
        
        // 通过调试，发现，iOS给了我们额外的10分钟（600s）来执行这个任务。
        
        self.backgroundTaskIdentifier = application.beginBackgroundTask(expirationHandler: {
            
            // 当应用程序留给后台的时间快要到结束时（应用程序留给后台执行的时间是有限的）， 这个Block块将被执行
            // 我们需要在次Block块中执行一些清理工作。
            // 如果清理工作失败了，那么将导致程序挂掉
            // 清理工作需要在主线程中用同步的方式来进行
            
            self.endBackgroundTask()
        })
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

