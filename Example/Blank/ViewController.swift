//
//  ViewController.swift
//  Blank
//
//  Created by ablett on 06/20/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

import UIKit
import Blank
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /// make blank
        var num = 0
        let blank:Blank = Blank(type: .fail, image:Blank.defaultBlankImage(type: .fail), title: NSAttributedString(string: "请求失败"), desc: NSAttributedString(string: "10014")) { (tap) -> (Void) in
            num += 1
            print("clicked:\(num)")
            self.view.blankConfReset()
        }
        
        /// set blank and reload
        view.setBlank(blank)
        view.reloadBlank()
        
        /// update style
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.view.updateBlankConf { (conf) in
                conf.backgorundColor = .black
                conf.titleFont = UIFont.boldSystemFont(ofSize: 14);
                conf.titleColor = .white
                conf.descFont = UIFont.boldSystemFont(ofSize: 14);
                conf.descColor = .white
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

