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
        
        let blank:Blank = Blank(type: .fail, image: UIImage(named: "blank_failure"), title: NSAttributedString(string: "请求失败"), desc: NSAttributedString(string: "10014")) { (tap) -> (Void) in
            num += 1
            print("clicked:\(num)")
        }
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        scrollView.setBlank(blank)
        scrollView.reloadBlank()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            scrollView.updateBlankConf {
                (conf) in
                conf.backgorundColor = UIColor.red.withAlphaComponent(0.1)
                conf.titleFont = UIFont.systemFont(ofSize: 14)
                conf.titleColor = .red
                conf.descColor = .orange
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

