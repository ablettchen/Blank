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
    public var tapEnable: Bool!
    
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
        self.tapEnable = true
    }
}

public class Blank: NSObject {
    
    /// blank type
    public var type: BlankType = .fail
    
    /// blank image
    public var image: UIImage?
    
    /// blank title
    public var title: NSAttributedString?
    
    /// blank desc
    public var desc: NSAttributedString?
    
    /// blank view tap action
    public var tap: ((_ :UITapGestureRecognizer)->(Void))?
    
    /// loadingView
    public var loadingImage: UIImage?
    
    /// is animating
    public var imageAnimating: Bool
    
    /// animation
    public var animation: CAAnimation {
        get {
            let ani = CABasicAnimation(keyPath: "transform")
            ani.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            ani.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat.pi*2, 0.0, 0.0, 1.0))
            ani.duration = 0.25
            ani.isCumulative = true
            ani.repeatCount = MAXFLOAT
            return ani
        }
    }
    
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
        return Blank.init(type: type, image: defaultBlankImage(type: type), title: title, desc: nil, tap: nil)
    }
    
    public class func defaultBlankImage(type: BlankType) -> UIImage? {
        switch type {
        case .fail:
            return UIImage(named: "")
        case .noData:
            return UIImage(named: "")
        case .noNetwork:
            return UIImage(named: "")
        }
    }

    public init(type: BlankType, image: UIImage?, title :NSAttributedString!, desc: NSAttributedString?, tap: ((_ :UITapGestureRecognizer)->(Void))? ) {

        self.imageAnimating = false
        self.loadingImage = UIImage(named: "222")
        
        self.tap = tap
        
        super.init()
        
        self.type = type
        self.image = image
        self.title = title
        self.desc = desc
    }
}

public class BlankView: UIView {
    
    private var conf:BLankConf!
    
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
        view.isUserInteractionEnabled = false
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

    public var blank:Blank! {
        didSet {
            self.imageView.image = blank.image
            self.titleLabel.attributedText = blank.title
            self.descLabel.attributedText = blank.desc
        }
    }
    
    public var update: (_ closure: (_ conf:BLankConf)-> (Void)) -> Void {
        get {
            return { (cls) -> Void in
                
                if self.conf == nil { self.conf = BLankConf() }
                cls(self.conf)
                
                self.backgroundColor = self.conf.backgorundColor

                /// title label
                self.titleLabel.font = self.conf.titleFont
                self.titleLabel.textColor = self.conf.titleColor
                /// desc label
                self.descLabel.font = self.conf.descFont
                self.descLabel.textColor = self.conf.descColor
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
        contentView.snp.removeConstraints()
    }
    
    public func prepare() -> Void {

        imageView.isHidden = !canShowImage
        titleLabel.isHidden = !canShowTitle
        descLabel.isHidden = !canShowDesc
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }

        var lastConstraint = contentView.snp.top
        
        if canShowImage {
            contentView.addSubview(imageView)
            imageView.snp_makeConstraints { (make) in
                make.top.equalTo(lastConstraint)
                make.width.centerX.equalToSuperview()
                make.height.equalTo(50)
            }
            lastConstraint = imageView.snp.bottom
        }
        
        if canShowTitle {
            contentView.addSubview(titleLabel)
            titleLabel.snp_makeConstraints { (make) in
                make.top.equalTo(lastConstraint).offset(canShowImage ? conf.titleToImagePadding : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = titleLabel.snp_bottom
        }

        if canShowDesc {
            contentView.addSubview(descLabel)
            descLabel.snp_makeConstraints { (make) in
                make.top.equalTo(lastConstraint).offset(canShowTitle ? conf.descToTitlePadding : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = descLabel.snp_bottom
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(lastConstraint).offset(conf.verticalOffset)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.contentView.alpha = 1.0
        }) { (finished) in }
    }
}

private var kBlankView = "kBlankView"
private var kBlank = "kBlank"

extension UIScrollView: UIGestureRecognizerDelegate {

    public var blankVisiable:Bool {
        get {
            return (blankView != nil);
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
            return { (cls) -> Void in
                
                let conf = BLankConf()
                cls(conf)
                
                self.blankView.update {
                    (config) in
                    config.backgorundColor      = conf.backgorundColor
                    config.titleFont            = conf.titleFont
                    config.titleColor           = conf.titleColor
                    config.descFont             = conf.descFont
                    config.descColor            = conf.descColor
                    config.verticalOffset       = conf.verticalOffset
                    config.titleToImagePadding  = conf.titleToImagePadding
                    config.descToTitlePadding   = conf.descToTitlePadding
                    config.tapEnable            = conf.tapEnable
                }
            }
        }
    }
    
    public func blankConfReset() -> Void {
        self.blankView.update {
            (conf) in
            conf.reset()
        }
    }
    
    private var blankView: BlankView! {
        get {
            if let view = objc_getAssociatedObject(self, &kBlankView) as? BlankView {
                return view;
            }
            let view:BlankView = BlankView(frame: frame);
            
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            tapGesture.delegate = self
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
            
            objc_setAssociatedObject(self, &kBlankView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view;
        }
        set {
            objc_setAssociatedObject(self, &kBlankView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func tapAction(_ gesture:UITapGestureRecognizer) -> Void {
        if let tap = self.blank.tap {
            tap(gesture)
        }
    }
    
    public func reloadBlank() -> Void {

        if canDisplay() && itemsCount() == 0 {
            
            if let view = blankView {
                
                if view.superview == nil {
                    if (self is UITableView || self is UICollectionView) || subviews.count > 1 {
                        self.insertSubview(view, at: 0)
                    }else {
                        self.addSubview(view);
                    }
                }
                
                view.reset()
                view.blank = blank
                view.isHidden = false
                view.prepare()
                
                view.snp.remakeConstraints { (make) in
                    make.size.equalToSuperview()
                    make.center.equalToSuperview()
                }
            }
            
        }else if blankVisiable {
            invalidate()
        }
    }
    
    private func canDisplay() -> (Bool) {
        return self.blank != nil;
    }
    
    private func itemsCount() -> (Int) {
        
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
    
    private func invalidate() -> (Void) {
        if let view = blankView {
            view.reset()
            view.isHidden = true
            view.removeFromSuperview()
        }
        self.isScrollEnabled = true
    }
    
}
