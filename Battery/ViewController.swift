//
//  ViewController.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/17.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        
//        let rm = RegionManager.shareInstance()
//        rm.locationManager.startUpdatingLocation()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(RegionManager.shareInstance())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

