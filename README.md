# LNHorizontalCollectionView

[![CI Status](http://img.shields.io/travis/Luan Nguyen/LNHorizontalCollectionView.svg?style=flat)](https://travis-ci.org/Luan Nguyen/LNHorizontalCollectionView)
[![Version](https://img.shields.io/cocoapods/v/LNHorizontalCollectionView.svg?style=flat)](http://cocoapods.org/pods/LNHorizontalCollectionView)
[![License](https://img.shields.io/cocoapods/l/LNHorizontalCollectionView.svg?style=flat)](http://cocoapods.org/pods/LNHorizontalCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/LNHorizontalCollectionView.svg?style=flat)](http://cocoapods.org/pods/LNHorizontalCollectionView)

## Example

A custom collection view flow layout with horizontal scrolling and paging.

## Demo

![image](https://github.com/luannguyenkhoa/UICollectionViewHorizontalFlowLayout/blob/master/CollectionViewHorizontalLayout/ScreenShot.png?raw=true)

## Usage

. Just adding code below into viewDidLoad func in your viewcontroller :

```
let flowLayout = HorizontalFlowLayout()
flowLayout?.maximumSpacing = 5
collectionView?.collectionViewLayout = flowLayout!
```

. Default value of the number cell in one row is 2.

. In order to change the number cell in one row, using ``let flowLayout = HorizontalFlowLayout(numberInOneRow: 3)`` instead.  

## Requirements

. Xcode 8

. Swift 3

## Installation

LNHorizontalCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod "LNHorizontalCollectionView"
```

## Author

Luan Nguyen, nkluan91@gmail.com

## License

LNHorizontalCollectionView is available under the MIT license. See the LICENSE file for more info.
