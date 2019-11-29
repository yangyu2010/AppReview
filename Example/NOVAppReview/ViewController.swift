//
//  ViewController.swift
//  NOVAppReview
//
//  Created by yangyu on 11/29/2019.
//  Copyright (c) 2019 yangyu. All rights reserved.
//

import UIKit
import NOVAppReview

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n" + NSHomeDirectory() + "\n")
     
    }
    
    @IBAction func action(_ sender: Any) {
        NOVAppReview.shared.showReview()
        
//        UIApplication.shared.open(URL(string: "https://www.baidu.com")!)

    }
    
  
    @IBAction func reset(_ sender: Any) {
        UserDefaults.standard.setValue(nil, forKey: "nov_app_review_info")
    }
}

