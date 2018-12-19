//
//  ViewController.swift
//  Battery
//
//  Created by 孙凌锋 on 2018/7/17.
//  Copyright © 2018年 孙凌锋. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 100, height: 20))
//        label.text = "123"
//        self.navigationController?.navigationItem.titleView = label;
        self.navigationController?.navigationItem.title = "ssss"
        
        print(NSHomeDirectory())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

