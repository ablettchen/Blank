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
        
        var num = 0
        let blank: Blank = Blank(type: .fail, image:Blank.image(.fail), title: "请求失败", desc: "10014") { tap in
            num += 1
            print("clicked:\(num)")
            self.view.blankConfReset()
        }
        
        view.atBlank = blank
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.reloadBlank()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.view.updateBlankConf { (conf) in
                conf.backgorundColor = .black
                conf.titleFont = .boldSystemFont(ofSize: 14);
                conf.titleColor = .white
                conf.descFont = .boldSystemFont(ofSize: 14);
                conf.descColor = .white
                conf.verticalOffset = 200
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

