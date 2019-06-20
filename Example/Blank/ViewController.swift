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
        
        /// add scrollView
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        /// make blank
        var num = 0
        let blank:Blank = Blank(type: .fail, image:Blank.defaultBlankImage(type: .fail), title: NSAttributedString(string: "请求失败"), desc: NSAttributedString(string: "10014")) { (tap) -> (Void) in
            num += 1
            print("clicked:\(num)")
            
            scrollView.blankConfReset()
        }
        
        /// set blank and reload
        scrollView.setBlank(blank)
        scrollView.reloadBlank()
        
        /// update style
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            scrollView.updateBlankConf {
                (conf) in
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

