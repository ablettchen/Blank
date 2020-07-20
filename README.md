# Blank

[![CI Status](https://img.shields.io/travis/ablett/Blank.svg?style=flat)](https://travis-ci.org/ablett/Blank)
[![Version](https://img.shields.io/cocoapods/v/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)
[![License](https://img.shields.io/cocoapods/l/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)
[![Platform](https://img.shields.io/cocoapods/p/Blank.svg?style=flat)](https://cocoapods.org/pods/Blank)

## Example


![](https://github.com/ablettchen/Blank/blob/master/Example/Screenshots/ss.png)


```swift

import Blank

    var num = 0
    let blank: Blank = Blank(type: .fail, image:Blank.defaultImage(type: .fail), title: "请求失败", desc: "10014") { tap in
        num += 1
        print("clicked:\(num)")
        self.view.blankConfReset()
    }
    
    view.setBlank(blank)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.view.reloadBlank()
    }

    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        self.view.updateBlankConf { (conf) in
            conf.backgorundColor = .black
            conf.titleFont = .boldSystemFont(ofSize: 14);
            conf.titleColor = .white
            conf.descFont = .boldSystemFont(ofSize: 14);
            conf.descColor = .white
            conf.verticalOffset = 200
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
