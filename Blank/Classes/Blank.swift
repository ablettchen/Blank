//
//  Blank.swift
//  Blank
//
//  Created by ablett on 2019/6/18.
//  Copyright © 2019 ablett. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public enum BlankType: Int {
    case fail
    case noData
    case noNetwork
}

public class Blank: NSObject {

    public var customBlankView: UIView?
    public var type: BlankType = .fail
    public var image: UIImage?
    public var title: NSAttributedString?
    public var desc: NSAttributedString?
    public var tap: ((_ : UITapGestureRecognizer) -> Void)?
    public var loadingImage: UIImage?
    public var isAnimating: Bool = false
    public var isTapEnable: Bool = true
    
    public lazy var animation: CAAnimation = {
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        anim.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0))
        anim.duration = 0.25
        anim.isCumulative = true
        anim.repeatCount = MAXFLOAT
        return anim
    }()

    public static func `default`(_ type: BlankType) -> Blank {
        var title: NSAttributedString!
        switch type {
        case .fail:
            title = NSAttributedString(string: "点击屏幕，重新加载～")
        case .noData:
            title = NSAttributedString(string: "暂无内容~")
        case .noNetwork:
            title = NSAttributedString(string: " 网络未连接\n请检查网络设置")
        }
        return Blank(type: type, image: image(type), title: title, desc: nil, tap: nil)
    }

    public static func image(_ type: BlankType) -> UIImage? {
        switch type {
        case .fail:         return UIImage.inBlank(named: "blank_fail")
        case .noData:       return UIImage.inBlank(named: "blank_nodata")
        case .noNetwork:    return UIImage.inBlank(named: "blank_nonetwork")
        }
    }

    public init(type: BlankType, image: UIImage? = nil, title: NSAttributedString?, desc: NSAttributedString? = nil, tap: ((_ :UITapGestureRecognizer) -> (Void))? = nil) {
        super.init()
        self.loadingImage = UIImage.inBlank(named: "blank_loading_circle")
        self.tap = tap
        self.type = type
        self.image = image
        self.title = title
        self.desc = desc
    }

    public init(type: BlankType, image: UIImage? = nil, title: String?, desc: String? = nil, tap: ((_ :UITapGestureRecognizer) -> (Void))? = nil) {
        super.init()
        self.loadingImage = UIImage.inBlank(named: "blank_loading_circle")
        self.tap = tap
        self.type = type
        self.image = image
        if let title = title {self.title = NSAttributedString.init(string: title)}
        if let desc = desc {self.desc = NSAttributedString.init(string: desc)}
    }
}
