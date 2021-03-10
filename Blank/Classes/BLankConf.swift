//
//  BLankConf.swift
//  Blank
//
//  Created by ablett on 2020/7/20.
//

import Foundation


public class BLankConf: NSObject {

    public var backgorundColor: UIColor!

    public var titleFont: UIFont!
    public var titleColor: UIColor!

    public var descFont: UIFont!
    public var descColor: UIColor!

    public var verticalOffset: Float!
    public var titleToImagePadding: Float!
    public var descToTitlePadding: Float!
    
    public var isTapEnable: Bool!
    
    override init() {
        super.init()
        
        reset()
    }
    
    public func reset() -> Void {
        
        self.backgorundColor = .white
        self.titleFont = .systemFont(ofSize: 14)
        self.titleColor = .init(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        self.descFont = .systemFont(ofSize: 12)
        self.descColor = .init(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
        self.verticalOffset = -11.0
        self.titleToImagePadding = 18.0
        self.descToTitlePadding = 10.0
        self.isTapEnable = true
        
    }
}
