//
//  BlankExtensions.swift
//  Blank
//
//  Created by ablett on 2020/7/20.
//


extension UIImage {

    static func inBlank(named name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.blank, compatibleWith: nil)
    }
}

extension Bundle {
    
    static var blank: Bundle? {
        if let bundlePath = Bundle(for: Blank.self).resourcePath?.appending("/Blank.bundle") {
            return Bundle(path: bundlePath)
        }
        return nil
    }
}

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

    public var blankVisiable: Bool {
        get {
            guard atBlank?.customBlankView == nil else {
                return !(atBlank?.customBlankView?.isHidden ?? true)
            }
            return (blankView != nil) ? !blankView.isHidden : false;
        }
    }

    public var atBlank: Blank? {
        set {
            if !canDisplay() {invalidate()}
            objc_setAssociatedObject(self, &AssociatedKeys.blank, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blank) as? Blank
        }
    }
    
    private var blankView: BlankView! {
        get {
            if let view = objc_getAssociatedObject(self, &AssociatedKeys.blankView) as? BlankView {
                return view;
            }
            let view:BlankView = BlankView(frame: frame);
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(at_tapAction))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
            objc_setAssociatedObject(self, &AssociatedKeys.blankView, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view;
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.blankView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var updateBlankConf: (_ block: (_ conf: BLankConf) -> Void) -> Void {
        get {
            return { (block) in
                let conf = BLankConf()
                block(conf)
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

    public func blankConfReset() {
        self.blankView.update { (conf) in
            conf.reset()
        }
    }

    public func resetBlank() {
        if blankVisiable {
            invalidate()
        }
    }
    
    public func reloadBlank() -> Void {
        if canDisplay() == false {
            return
        }
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
            if let view = atBlank?.customBlankView {
                addBlankView?(view)
                view.isHidden = false
            }else if let view = blankView {
                view.reset()
                addBlankView?(view)
                view.isHidden = false
                view.blank = atBlank
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
}

extension UIView {
    
    private func canDisplay() -> Bool {
        return atBlank != nil;
    }
    
    private func invalidate() {
        if let view = atBlank?.customBlankView {
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
    
    @objc
    private func at_tapAction(_ gesture:UITapGestureRecognizer) -> Void {
        if atBlank == nil {return}
        if atBlank?.isTapEnable == false {return}
        if let tap = atBlank?.tap {tap(gesture)}
    }
    
    private struct AssociatedKeys {
        static var blank = "blank"
        static var blankView = "blankView"
    }
}

