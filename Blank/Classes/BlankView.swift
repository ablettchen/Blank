//
//  BlankView.swift
//  Blank
//
//  Created by ablett on 2020/7/20.
//

import UIKit

private let animationKey = "animationKey"

/// 空白页
public class BlankView: UIView {
    
    /// 配置
    private var conf: BLankConf?
    
    /// 内容
    private lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    /// 图片
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center;
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// 描述
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center;
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    /// 描述实例
    public var blank: Blank? {
        didSet {
            if let blank = blank {
                self.imageView.image = blank.isAnimating ? blank.loadingImage : blank.image
                self.titleLabel.attributedText = blank.title
                self.descLabel.attributedText = blank.desc
            }
        }
    }
    
    /// 更新配置
    public var update: (_ closure: (_ conf: BLankConf) -> Void) -> Void {
        get {
            return { [weak self] (block) in

                let conf = self?.conf ?? BLankConf()
                self?.conf = conf
                if self != nil {block(conf)}
                
                self?.isUserInteractionEnabled = conf.isTapEnable
                self?.backgroundColor = conf.backgorundColor
                self?.titleLabel.font = conf.titleFont
                self?.titleLabel.textColor = conf.titleColor
                self?.descLabel.font = conf.descFont
                self?.descLabel.textColor = conf.descColor
                
                if let sview = self?.contentView.superview {
                    self?.contentView.snp.updateConstraints({ (make) in
                        make.centerY.equalTo(sview).offset((conf.verticalOffset ?? 0))
                    })
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.conf = BLankConf()
        self.update { (conf) in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BlankView {
    
    /// 重置
    public func reset() {
        for view in contentView.subviews {view.removeFromSuperview()}
        contentView.alpha = 0
        imageView.image = nil
        titleLabel.text = nil
        descLabel.text = nil
    }
    
    /// 准备
    public func prepare() {
        
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
                make.top.equalTo(lastConstraint).offset(canShowImage ? conf?.titleToImagePadding ?? 0 : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = titleLabel.snp_bottom
        }
        
        if canShowDesc {
            contentView.addSubview(descLabel)
            descLabel.snp.makeConstraints { (make) in
                make.top.equalTo(lastConstraint).offset(canShowTitle ? conf?.descToTitlePadding ?? 0 : 0.0)
                make.width.centerX.equalTo(contentView)
            }
            lastConstraint = descLabel.snp_bottom
        }
        
        contentView.snp.makeConstraints { (make) in
            make.bottom.equalTo(lastConstraint)
        }
        
        contentView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview().offset(conf?.verticalOffset ?? 0)
        }
        
        if let blank = self.blank {
            if blank.isAnimating {
                self.imageView.layer.add(blank.animation, forKey: animationKey)
            }else if self.imageView.layer.animation(forKey: animationKey) != nil {
                self.imageView.layer.removeAnimation(forKey: animationKey)
            }
        }
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.contentView.alpha = 1.0
            }
        ) { (finished) in

        }
    }
}

extension BlankView {
    
    /// 是否能显示图片
    private var canShowImage: Bool {
        return ((imageView.image) != nil)
    }
    
    /// 是否能显示标题
    private var canShowTitle: Bool {
        if let attributedText = titleLabel.attributedText {
            return (attributedText.length > 0)
        }
        return false
    }
    
    /// 是否能显示描述
    private var canShowDesc: Bool {
        if let attributedText = descLabel.attributedText {
            return (attributedText.length > 0)
        }
        return false
    }
    
}
