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

/// blank view type
public enum BlankType: Int, CustomStringConvertible {
    case fail
    case noData
    case noNetwork
    
    public var description: String {
        switch self {
        case .fail:         return "fail"
        case .noData:       return "no data"
        case .noNetwork:    return "no network"
        }
    }
}

public class BLankConf: NSObject {
     
    /// backgorundColor
    public var backgorundColor: UIColor!
    
    /// title
    public var titleFont: UIFont!
    public var titleColor: UIColor!
    
    /// desc
    public var descFont: UIFont!
    public var descColor: UIColor!
    
    /// layout parameters
    public var verticalOffset: Float!
    public var titleToImagePadding: Float!
    public var descToTitlePadding: Float!
    
    /// tap action enable or disable
    public var isTapEnable: Bool!
    
    override init() {
        super.init()
        reset()
    }
    
    public func reset() -> Void {
        self.backgorundColor = .white
        
        self.titleFont = .systemFont(ofSize: 14)
        self.titleColor = .darkGray
        
        self.descFont = .systemFont(ofSize: 12)
        self.descColor = .gray
        
        self.verticalOffset = 0.0
        self.titleToImagePadding = 15.0
        self.descToTitlePadding = 10.0
        self.isTapEnable = true
    }
}

public class Blank: NSObject {
    
    /// custom blank view
    public var customBlankView: UIView?
    
    /// blank type
    public var type: BlankType = .fail
    
    /// blank image
    public var image: UIImage?
    
    /// blank title
    public var title: NSAttributedString?
    
    /// blank desc
    public var desc: NSAttributedString?
    
    /// blank view tap action
    public var tap: ((_ :UITapGestureRecognizer) -> (Void))?
    
    /// loadingView
    public var loadingImage: UIImage?
    
    /// is animating
    public var isAnimating: Bool = false
    
    /// is tap enable
    public var isTapEnable: Bool = true
    
    /// animation
    lazy public var animation: CAAnimation! = {
        let ani = CABasicAnimation(keyPath: "transform")
        ani.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        ani.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi/2, 0.0, 0.0, 1.0))
        ani.duration = 0.25
        ani.isCumulative = true
        ani.repeatCount = MAXFLOAT
        return ani
    }()
    
    public class func defaultBlank(type: BlankType) -> Blank {
        var title: NSAttributedString!
        switch type {
        case .fail:
            title = NSAttributedString(string: "请求失败")
        case .noData:
            title = NSAttributedString(string: "暂时没有数据～")
        case .noNetwork:
            title = NSAttributedString(string: "哎呀,断网了～")
        }
        return Blank(type: type, image: defaultBlankImage(type: type), title: title, desc: nil, tap: nil)
    }
    
    private class func blankBundle() -> Bundle? {
        if let bundlePath = Bundle(for: Blank.self).resourcePath?.appending("/Blank.bundle") {
            return Bundle(path: bundlePath)
        }
        return nil
    }
    
    public class func defaultBlankImage(type: BlankType) -> UIImage? {
        switch type {
        case .fail:
            return UIImage(named: "blank_fail", in: blankBundle(), compatibleWith: nil)
        case .noData:
            return UIImage(named: "blank_nodata", in: blankBundle(), compatibleWith: nil)
        case .noNetwork:
            return UIImage(named: "blank_nonetwork", in: blankBundle(), compatibleWith: nil)
        }
    }
    
    public init(type: BlankType, image: UIImage?, title :NSAttributedString!, desc: NSAttributedString?, tap: ((_ :UITapGestureRecognizer) -> (Void))? ) {
        
        super.init()
        
        self.loadingImage = UIImage(named: "blank_loading_circle", in: Blank.blankBundle(), compatibleWith: nil)
        self.tap = tap
        
        self.type = type
        self.image = image
        self.title = title
        self.desc = desc
        
    }
}

private var kImageView = "kImageView"

public class BlankView: UIView {
    
    private var conf: BLankConf!
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.alpha = 0
        view.accessibilityIdentifier = "blank content view"
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.accessibilityIdentifier = "blank image"
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center;
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.accessibilityIdentifier = "blank title"
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center;
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.accessibilityIdentifier = "blank desc"
        return label
    }()
    
    public var blank: Blank! {
        didSet {
            self.imageView.image = blank.isAnimating ? blank.loadingImage : blank.image
            self.titleLabel.attributedText = blank.title
            self.descLabel.attributedText = blank.desc
        }
    }
    
    public var update: (_ closure: (_ conf:BLankConf) -> (Void)) -> Void {
        get {
            return { [weak self] (cls) in
                
                if self?.conf == nil {self?.conf = BLankConf()}
                if self != nil {cls(self!.conf)}
                
                self?.backgroundColor = self!.conf.backgorundColor
                
                /// title label
                self?.titleLabel.font = self!.conf.titleFont
                self?.titleLabel.textColor = self!.conf.titleColor
                /// desc label
                self?.descLabel.font = self!.conf.descFont
                self?.descLabel.textColor = self!.conf.descColor
            }
        }
    }
    
    private var canShowImage: Bool {
        return ((imageView.image) != nil)
    }
    
    private var canShowTitle: Bool {
        if let attributedText = titleLabel.attributedText {
            return (attributedText.length > 0)
        }
        return false
    }
    
    private var canShowDesc: Bool {
        if let attributedText = descLabel.attributedText {
            return (attributedText.length > 0)
        }
        return false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.conf = BLankConf()
        self.update {
            (conf) in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reset() -> Void {
        for view in contentView.subviews {view.removeFromSuperview()}
        contentView.alpha = 0
        imageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
    }
    
    public func prepare() -> Void {
        
        imageView.isHidden = !canShowImage
        titleLabel.isHidden = !canShowTitle
        descLabel.isHidden = !canShowDesc
        
        self.addSubview(contentView)
        contentView.snp.remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        var lastConstraint = contentView.snp.top
        
        if canShowImage {
            contentView.addSubview(imageView)
            imageView.snp.remakeConstraints { (make) in
                make.top.equalTo(lastConstraint)
                make.centerX.equalToSuperview()
                make.size.equalTo(imageView.image?.size ?? 0)
            }
            lastConstraint = imageView.snp.bottom
        }
        
        if canShowTitle {
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(lastConstraint).offset(canShowImage ? conf.titleToImagePadding : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = titleLabel.snp_bottom
        }
        
        if canShowDesc {
            contentView.addSubview(descLabel)
            descLabel.snp.makeConstraints { (make) in
                make.top.equalTo(lastConstraint).offset(canShowTitle ? conf.descToTitlePadding : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = descLabel.snp_bottom
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(lastConstraint).offset(conf.verticalOffset)
        }
        
        if self.blank.isAnimating {
            if let animation = self.blank.animation {
                self.imageView.layer.add(animation, forKey: "BlankImageViewAnimationKey")
            }
        }else if self.imageView.layer.animation(forKey: "BlankImageViewAnimationKey") != nil {
            self.imageView.layer.removeAnimation(forKey: "BlankImageViewAnimationKey")
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { [weak self] in
            self?.contentView.alpha = 1.0
        }) { (finished) in }
        
    }
}

private var kBlankView = "kBlankView"
private var kBlank = "kBlank"

extension UIScrollView {
    
    public func itemsCount() -> (Int) {
        
        var items = 0
        
        if let tableView = self as? UITableView {
            var sections = 1
            
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: tableView)
                }
                if dataSource.responds(to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.tableView(tableView, numberOfRowsInSection: i)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            var sections = 1
            
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
                    sections = dataSource.numberOfSections!(in: collectionView)
                }
                if dataSource.responds(to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) {
                    for i in 0 ..< sections {
                        items += dataSource.collectionView(collectionView, numberOfItemsInSection: i)
                    }
                }
            }
        }
        return items
    }
}

extension UIView {
    
    public var blankVisiable:Bool {
        get {
            guard self.blank.customBlankView == nil else {
                return !self.blank.customBlankView!.isHidden
            }
            return (blankView != nil) ? !blankView.isHidden : false;
        }
    }
    
    private var blank: Blank! {
        get {
            return objc_getAssociatedObject(self, &kBlank) as? Blank
        }
    }
    
    public func setBlank(_ newValue:Blank) -> Void {
        if !canDisplay() {
            invalidate()
        }
        objc_setAssociatedObject(self, &kBlank, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
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
    
    public func blankConfReset() -> Void {
        self.blankView.update { (conf) in
            conf.reset()
        }
    }
    
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
        if !self.blank.isTapEnable {return}
        if let tap = self.blank.tap {
            tap(gesture)
        }
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
            
            let addBlankView:((_ view: UIView) -> Void)? = { [weak self] (view) in
                
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
            
            
            if let view = self.blank.customBlankView {
                
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
    
    private func canDisplay() -> (Bool) {
        return self.blank != nil;
    }
    
    private func invalidate() -> (Void) {
        
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
