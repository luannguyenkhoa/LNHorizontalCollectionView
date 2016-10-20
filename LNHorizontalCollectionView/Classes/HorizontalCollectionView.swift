//
//  HorizontalLayout.swift
//  CollectionViewHorizontalLayout
//
//  Created by Luan Nguyen on 6/27/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//

import UIKit
import Darwin

public class HorizontalFlowLayout: UICollectionViewLayout {
  
  typealias Handler = (section: Int, page: Int, pageOffset: Int, itemsInSection: Int,
    itemsInPage: Int, framesInSection: inout Array<NSString>) -> ()

  public var maximumSpacing: CGFloat = 0
  
  // Enable collection view paging option
  private var isPagingEnabled = true
  private var itemsInOneRow: Int = 2
  // Cast int to cgfloat
  private var numberInCGFloat: CGFloat {
    return CGFloat(itemsInOneRow)
  }
  private var pageSize = CGSize.zero
  private var itemSize = CGSize.zero
  private var frames = Array<[String]>()
  private lazy var calculateLayout: ()? = { [unowned self] in
    self.calculateLayoutProperties()
    }()
  
  // Initial self with a special number of items in one row
  public convenience init(itemsInOneRow: Int) {
    self.init()
    self.itemsInOneRow = itemsInOneRow
  }
  
  // Release lazy variable
  public func releaseCalculating() {
    calculateLayout = nil
  }
  
  // Calculate properties includes page size, item size, line scpace, interitem space
  private func calculateLayoutProperties() {
    // Enable paging
    self.collectionView?.pagingEnabled = isPagingEnabled
    
    let spacing = (maximumSpacing*(numberInCGFloat+1))
    pageSize = collectionView?.bounds.size ?? CGSize.zero
    
    // The item size is the division result between page size and number of items on one page
    let itemWidth = (pageSize.width - spacing) / numberInCGFloat
    let itemHeight = (pageSize.height - spacing) / numberInCGFloat
    
    itemSize = CGSize(width: itemWidth, height: itemHeight)
  }
  
  // Calculate number of pages in a specific section
  private func pagesInSection(section: Int) -> Int {
    guard let collectionView = collectionView else {
      return 0
    }
    return (collectionView.numberOfItemsInSection(section) - 1) / Int(pow(numberInCGFloat, 2)) + 1
  }
  
  override public func collectionViewContentSize() -> CGSize {
    let sections = collectionView?.numberOfSections() ?? 0
    let pages = Array(0..<sections).reduce(0, combine: { $0 + pagesInSection($1) })
    return CGSize(width: CGFloat(pages) * pageSize.width, height: pageSize.height)
  }
  
  public override func prepareLayout() {
    // Just only calculate layout properties once
    _ = calculateLayout
    // Clear list frames
    frames.removeAll()
    
    frames = lift { [unowned self] (_, page, pagesOffset, itemsInSection, itemsInPage, framesInSection) in
      let itemsToAddToArray = itemsInSection - framesInSection.count
      let itemsInCurrentPage = itemsToAddToArray < itemsInPage ? itemsToAddToArray : itemsInPage
      for itemInPage in 0..<itemsInCurrentPage {
        
        // Calculate frame of each item on the page
        let yspace = itemInPage >= self.itemsInOneRow ? self.maximumSpacing : 0
        let originX = self.calculateOriginX(page, index: itemInPage, pagesOffset: pagesOffset)
        let originY = CGFloat(itemInPage / self.itemsInOneRow) * self.itemSize.height + self.maximumSpacing + yspace
        let itemFrame = CGRect(origin: CGPoint(x: originX, y: originY), size: self.itemSize)
        framesInSection.append(NSStringFromCGRect(itemFrame) as NSString)
      }
    }
  }
  
  private func calculateOriginX(page: Int, index: Int, pagesOffset: Int) -> CGFloat {
    return maximumSpacing * CGFloat(index % itemsInOneRow + 1) + itemSize.width *
      CGFloat(index % itemsInOneRow) + pageSize.width * CGFloat(page + pagesOffset)
  }
  
  public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attributes = [UICollectionViewLayoutAttributes]()
      
    _ = lift { [unowned self] (section, page, pagesOffset, itemsInSection, itemsInPage, _) in
        let pageFrame = CGRect(origin: CGPoint(x: CGFloat(pagesOffset + page) * self.pageSize.width, y: 0), size: self.pageSize)
        // Check if the rect intersects page frame, do something then
        if rect.intersects(pageFrame) {
          // Calculate item starts at index and number of items in current page
          let startItemIndex = page * itemsInPage
          let itemsInCurrentPage = itemsInSection - startItemIndex < itemsInPage ? itemsInSection - startItemIndex : itemsInPage
          
          for itemInPage in 0..<itemsInCurrentPage {
            // Get layout attributes of each indexPath
            let itemAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: startItemIndex + itemInPage, inSection: section))
            // Check intersection between inputting rect and item attribute frame
            if let itemAttributes = itemAttributes where itemAttributes.frame.intersects(rect) {
              attributes.append(itemAttributes)
            }
          }
        }
    }
    
    return attributes
  }
  
  // A common function with handler closure as a parameter
  private func lift(handler: Handler) -> Array<[String]> {
    // Get number of sections from superview
    let sections = collectionView?.numberOfSections() ?? 1
    // Initial default returns value
    var res = Array<[String]>()
    // Initial page offset and items in page
    var pagesOffset = 0
    let itemsInPage = Int(pow(numberInCGFloat, 2))
    
    for section in 0..<sections {
      // Get pages and items in current section
      let pagesInSection: Int = self.pagesInSection(section)
      let itemsInSection: Int = collectionView?.numberOfItemsInSection(section) ?? 0
      
      var framesInSection = Array<NSString>()
      // Perform handler on each of pages
      for page in 0..<pagesInSection {
        handler(section: section, page: page, pageOffset: pagesOffset, itemsInSection: itemsInSection, itemsInPage: itemsInPage, framesInSection: &framesInSection)
      }
      // Save result after calcuating all properties of pages of this section
      res.append(framesInSection as! [String])
      // Add pages offset value by number pages in section
      pagesOffset += pagesInSection
    }
    return res
  }
  
  public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    // Convert calculated frame string to rect for each item to determines its attributes
    attributes.frame = CGRectFromString(frames[indexPath.section][indexPath.item])
    return attributes
  }
  
}
