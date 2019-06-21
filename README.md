# Blank

[![CI Status](https://img.shields.io/travis/ablett/Blank.svg?style=flat)](https://travis-ci.org/ablett/Blank)
[![Version](https://img.shields.io/cocoapods/v/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)
[![License](https://img.shields.io/cocoapods/l/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)
[![Platform](https://img.shields.io/cocoapods/p/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)

## Example


![](https://github.com/ablettchen/Blank/blob/master/Example/Screenshots/ss.png)


```swift

import Blank

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

```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Blank is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Blank'
```

## Author

ablett, ablettchen@gmail.com

## License

Blank is available under the MIT license. See the LICENSE file for more info.
