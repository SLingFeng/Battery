//
//  CoreDataManager.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/18.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    ///当前上下文
    public  lazy var mangerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        ///需要设置一个调度器
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
//    2、调度器的创建
    ///调度器  设置保存的路径
    public lazy var   persistentStoreCoordinator:NSPersistentStoreCoordinator = {
        //需要保存的Datamodle
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:self.mangerModel)
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "db.sqlite", relativeTo: dirURL)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        return coordinator
    }()
//    3、  DataModel
    //调度器管理 model 也就是 创建的DataModel
    public   lazy var mangerModel:NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "RegionDataModel", withExtension: "momd") else{
            fatalError("加载错误")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else{
            fatalError("加载错误")
        }
        return model
    }()
}
