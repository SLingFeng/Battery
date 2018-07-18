//
//  RegionModel+CoreDataProperties.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/18.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//
//

import Foundation
import CoreData


extension RegionModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegionModel> {
        return NSFetchRequest<RegionModel>(entityName: "RegionModel")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var startTime: NSDate?
    @NSManaged public var endTime: NSDate?

}
