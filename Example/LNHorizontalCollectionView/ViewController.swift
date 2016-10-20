//
//  ViewController.swift
//  CollectionViewHorizontalLayout
//
//  Created by Luan Nguyen on 6/27/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//

import UIKit
import LNHorizontalCollectionView

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  
  private var flowLayout: HorizontalFlowLayout?
  internal var listItems: Array<[String: String]> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    // initial content
    let leftImages = Array(repeating: ["image": "left-side", "title": "Da Nang - Love Brigde"], count: 10)
    let rightImages = Array(repeating: ["image": "right-side", "title": "Da Nang - DHC-Marina"], count: 10)
    listItems =  zip(leftImages, rightImages).flatMap({ [$0.0, $0.1]})
    
    // Number of items in one row
    let numberInOneRow = 2
    
    flowLayout = HorizontalFlowLayout(itemsInOneRow: numberInOneRow)
    flowLayout?.maximumSpacing = 5
    collectionView?.collectionViewLayout = flowLayout!
    
    // Config number of pages for UIPageControl
    // the number of pages will be devision of sum of items and square of numberInOneRow
    pageControl.numberOfPages = Int(ceil(Double(listItems.count) / pow(Double(numberInOneRow), 2)))
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func lazyLoadLocalImage(named: String, forImgView: UIImageView) {
    DispatchQueue.global().async {
      let img = UIImage(named: named)
      DispatchQueue.main.async(execute: {
        forImgView.image = img
      })
    }
  }
  
}

extension ViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "initialCell", for: indexPath)
    // Render image by named to imageview
    if let imgView = cell.viewWithTag(101) as? UIImageView {
      let named = listItems[indexPath.row]["image"] ?? ""
      lazyLoadLocalImage(named: named, forImgView: imgView)
    }
    // Render title text to label
    if let lb = cell.viewWithTag(102) as? UILabel {
      lb.text = listItems[indexPath.row]["title"]
    }
    
    // Number of cell
    if let numLb = cell.viewWithTag(103) as? UILabel {
      numLb.text = "\(indexPath.row + 1)"
    }
    
    return cell
  }
}

extension ViewController: UICollectionViewDelegate {
  
}

extension ViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Update UIPageControl current page while horizontal scrolling
    let pageWidth = collectionView.bounds.size.width
    pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
  }
}
