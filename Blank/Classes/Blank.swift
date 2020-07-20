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

/// 空白页类型
public enum BlankType: Int, CustomStringConvertible {
    
    /// 请求失败
    case fail
    
    /// 无数据
    case noData
    
    /// 无网络连接
    case noNetwork
    
    public var description: String {
        switch self {
        case .fail:         return "fail"
        case .noData:       return "no data"
        case .noNetwork:    return "no network"
        }
    }
}

/// 空白页描述
public class Blank: NSObject {
    
    /// 自定义视图
    public var customBlankView: UIView?
    
    /// 类型
    public var type: BlankType = .fail
    
    /// 图片
    public var image: UIImage?
    
    /// 标题
    public var title: NSAttributedString?
    
    /// 描述
    public var desc: NSAttributedString?
    
    /// 点击事件
    public var tap: ((_ :UITapGestureRecognizer) -> (Void))?
    
    /// 加载图片
    public var loadingImage: UIImage?
    
    /// 是否正在执行动画
    public var isAnimating: Bool = false
    
    /// 是否允许点击
    public var isTapEnable: Bool = true
    
    /// 旋转动画
    lazy public var animation: CAAnimation = {
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        anim.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi / 2.0, 0.0, 0.0, 1.0))
        anim.duration = 0.25
        anim.isCumulative = true
        anim.repeatCount = MAXFLOAT
        return anim
    }()
    
    /// 默认空白页描述
    /// - Parameter type: 类型
    /// - Returns: 空白页描述实例
    public static func `default`(type: BlankType) -> Blank {
        var title: NSAttributedString!
        switch type {
        case .fail:
            title = NSAttributedString(string: "请求失败")
        case .noData:
            title = NSAttributedString(string: "暂时没有数据～")
        case .noNetwork:
            title = NSAttributedString(string: "哎呀,断网了～")
        }
        return Blank(type: type, image: image(type: type), title: title, desc: nil, tap: nil)
    }
    
    /// 获取默认图片
    /// - Parameter type: 类型
    /// - Returns: 图片
    public class func image(type: BlankType) -> UIImage? {
        switch type {
        case .fail:         return UIImage.inBlank(named: "blank_fail")
        case .noData:       return UIImage.inBlank(named: "blank_nodata")
        case .noNetwork:    return UIImage.inBlank(named: "blank_nonetwork")
        }
    }
    
    /// 初始化方法
    /// - Parameters:
    ///   - type: 类型
    ///   - image: 图片
    ///   - title: 标题
    ///   - desc: 描述
    ///   - tap: 点击事件
    public init(type: BlankType, image: UIImage? = nil, title: NSAttributedString?, desc: NSAttributedString? = nil, tap: ((_ :UITapGestureRecognizer) -> (Void))? = nil) {
        super.init()
        self.loadingImage = UIImage.inBlank(named: "blank_loading_circle")
        self.tap = tap
        self.type = type
        self.image = image
        self.title = title
        self.desc = desc
    }
    
    /// 初始化方法
    /// - Parameters:
    ///   - type: 类型
    ///   - image: 图片
    ///   - title: 标题
    ///   - desc: 描述
    ///   - tap: 点击事件
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

private var kImageView = "kImageView"
private var kBlankView = "kBlankView"
private var kBlank = "kBlank"

extension UIView {
    
    /// 空白页是否可见
    public var blankVisiable: Bool {
        get {
            guard self.blank?.customBlankView == nil else {
                return !(self.blank?.customBlankView?.isHidden ?? true)
            }
            return (blankView != nil) ? !blankView.isHidden : false;
        }
    }
    
    /// 空白页描述实例
    private var blank: Blank? {
        get {
            return objc_getAssociatedObject(self, &kBlank) as? Blank
        }
    }
    
    /// 设置空白页描述实例
    public func setBlank(_ newValue: Blank) {
        if !canDisplay() {invalidate()}
        objc_setAssociatedObject(self, &kBlank, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 更新空白页配置
    public var updateBlankConf: (_ closure: (_ conf:BLankConf)-> (Void)) -> Void {
        get {
            return { (cls) in
                
                let conf = BLankConf()
                cls(conf)
                
                self.blankView.update { (config) in
                    config.backgorundColor      = conf.backgorundColor
                    config.titleFont            = conf.titleFont
                    config.titleColor           = conf.titleColor
                    config.descFont             = conf.descFont
                    config.descColor            = conf.descColor
                    config.verticalOffset       = conf.verticalOffset
                    config.titleToImagePadding  = conf.titleToImagePadding
                    config.descToTitlePadding   = conf.descToTitlePadding
                    config.isTapEnable          = conf.isTapEnable
                }
            }
        }
    }
    
    /// 重置空白页
    public func blankConfReset() {
        self.blankView.update { (conf) in
            conf.reset()
        }
    }
    
    /// 空白页视图
    private var blankView: BlankView! {
        get {
            if let view = objc_getAssociatedObject(self, &kBlankView) as? BlankView {
                return view;
            }
            let view:BlankView = BlankView(frame: frame);
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(at_tapAction))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
            
            objc_setAssociatedObject(self, &kBlankView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view;
        }
        set {
            objc_setAssociatedObject(self, &kBlankView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func at_tapAction(_ gesture:UITapGestureRecognizer) -> Void {
        if self.blank == nil {return}
        if self.blank?.isTapEnable == false {return}
        if let tap = self.blank?.tap {tap(gesture)}
    }
    
    public func resetBlank() {
        if blankVisiable {invalidate()}
    }
    
    public func reloadBlank() -> Void {
        
        if canDisplay() == false {return}
        
        var count = 0
        if (self is UIScrollView) {
            let sv: UIScrollView = self as! UIScrollView
            count = sv.itemsCount()
        }

        if count == 0 {
            
            let addBlankView: ((_ view: UIView) -> Void)? = { [weak self] (view) in
                
                if view.superview == nil {
                    if (self is UITableView || self is UICollectionView) || (self?.subviews.count ?? 0) > 1 {
                        self?.insertSubview(view, at: 0)
                    }else {
                        self?.addSubview(view);
                    }
                }
                
                view.snp.remakeConstraints { (make) in
                    make.size.centerX.centerY.equalToSuperview()
                }
            }
            
            if let view = self.blank?.customBlankView {
                
                addBlankView?(view)
                view.isHidden = false
                
            }else if let view = blankView {
                
                view.reset()
                addBlankView?(view)
                view.isHidden = false
                view.blank = blank
                view.isHidden = false
                view.prepare()
            }
            
            if (self is UIScrollView) {
                let sv: UIScrollView = self as! UIScrollView
                sv.isScrollEnabled = false
            }
            
        }else if blankVisiable {
            invalidate()
        }
    }
    
    private func canDisplay() -> Bool {
        return self.blank != nil;
    }
    
    private func invalidate() {
        
        if let view = self.blank?.customBlankView {
            view.isHidden = true
            view.removeFromSuperview()
        }else if let view = blankView {
            view.reset()
            view.isHidden = true
            view.removeFromSuperview()
        }
        if (self is UIScrollView) {
            let sv: UIScrollView = self as! UIScrollView
            sv.isScrollEnabled = true
        }
    }
    
}
