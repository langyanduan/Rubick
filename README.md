# Rubick


## Basic
#### File Manager
#### Encoder、Encryptor/Decryptor
#### class/struct extension

    ```swift
    // class extension
    let image = UIImage(named: "xxx")
    let tintImage = image?.ext.image(withTintColor: UIColor.red)
    
    // struct extension
    let text = "This is a string"
    let count = text.ext.count
    ```

## UI Component

* Pull refresh, loading more
* UITableView/UICollectionView empty placeholder
* Animation Indicator
* KeyboardManager
* Toast, ~~HUD~~  
  ...

## AutoLayout
#### Basic 

```
activateLayoutConstraints([
    view1.left == view2,
    view1.right == view2,
    view1.top == view.bottom,
    view1.width == 30
])
```

or

```
activateLayoutConstraints(view1, view2) { (view1, view2) in [
    view1.left == view2,
    view1.right == view2,
    view1.top == view.bottom,
    view1.width == 30
]}
```

more

```
activateLayoutConstraints(view1, view2) { (view1, view2) in [
    view1.edges == view2.insets(top: 5, left: 0, bottom: 5, right: 0)
]}
```


#### Line Layout

H: | - 5 - view1(=10) - 20 - view2(<=15) - view3(=view2) - view4 - (>=50) - view5 - |


```
activateLineLayout(head: contentView.DSL.left, tail: contentView.DSL.right, axis: .horizontal, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

or

```
activateLineLayout(in: contentView, axis: .horizontal, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

or 

```
activateHorizontalLayout(in: contentView, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

About `option`

when axis is horizontal, `head`, `center`, `tail` means `top`, `centerY`, `bottom`, otherwise means `left`, `centerX`, `right`


if `view1`~`view5` aligh top to contentView,

`options` should be

``` 
let options: LineLayoutOption = [
    .alignHead(to: contentView)
]
```

other option

```
let options: LineLayoutOption = [
    .heightEqual(to: 30),
    .widthEqual(to: otherView)
]
```

## Network
## Cache
## Image download queue



## 支持

需要 `iOS 8` 及以上

## 参考第三方库

* [Device](https://github.com/Ekhoo/Device)
* [DeviceGuru](https://github.com/InderKumarRathore/DeviceGuru)
* [Then](https://github.com/devxoul/Then)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [AlamofireNetworkActivityIndicator](https://github.com/Alamofire/AlamofireNetworkActivityIndicator)
* [APIKit](https://github.com/ishkawa/APIKit)
* [Moya](https://github.com/Moya/Moya)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [YYWebImage](https://github.com/ibireme/YYWebImage)
* [YYKeyboardManager](https://github.com/ibireme/YYKeyboardManager)
* [YYCache](https://github.com/ibireme/YYCache)
* [Cache](https://github.com/soffes/Cache)
* [Crypto](https://github.com/soffes/Crypto)
* [IDZSwiftCommonCrypto](https://github.com/iosdevzone/IDZSwiftCommonCrypto)
* [GenericKeychain](https://developer.apple.com/library/content/samplecode/GenericKeychain/Introduction/Intro.html)