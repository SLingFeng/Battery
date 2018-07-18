//
//  DataManager.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/18.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {

    //获取所有保存的
    public class func getDataList(mc : NSManagedObjectContext) -> Array<RegionModel> {
        
        let s : NSFetchRequest<RegionModel> = RegionModel.fetchRequest()
        do {
            let fetchedResults = try mc.fetch(s)
//            print(fetchedResults)
            return fetchedResults
        } catch  {
            fatalError("获取失败")
        }
    }
    //保存经纬度
    public class func saveModel(mc : NSManagedObjectContext, model :RegionModel) {
        do {
            try mc.save()
        } catch let error as NSError {
            debugPrint("context save error:\(error),description:\(error.userInfo)")
        }

    }
}
