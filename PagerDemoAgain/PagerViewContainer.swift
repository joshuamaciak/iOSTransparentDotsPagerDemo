//
//  PagerViewContainer.swift
//  PagerDemoAgain
//
//  Created by Joshua Maciak on 7/7/20.
//  Copyright © 2020 Joshua Maciak. All rights reserved.	
//

import Foundation
import UIKit

class PagerViewContainer: UIViewController, OnPageChangeListener {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        let pager = self.children.first as! PagerViewController
        pager.listener = self
    }
    
    func onPageCountChange(count: Int) {
        pageControl.numberOfPages = count
    }
    
    func onPageChange(index: Int) {
        print("page change: \(index)")
        pageControl.currentPage = index
    }
    
}
