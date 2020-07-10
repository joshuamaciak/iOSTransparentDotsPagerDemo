//
//  PagerViewController.swift
//  PagerDemoAgain
//
//  Created by Joshua Maciak on 7/6/20.
//  Copyright © 2020 Joshua Maciak. All rights reserved.
//

import Foundation
import UIKit

class PagerViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("red"),
            self.newColoredViewController("green"),
            self.newColoredViewController("blue"), self.newColoredViewController("green")]
    }()
    
    private var mListener: OnPageChangeListener?
    var listener: OnPageChangeListener? {
        set(newListener) {
            self.mListener = newListener
            self.listener?.onPageCountChange(count: orderedViewControllers.count)
        }
        
        get {
            return self.mListener
        }
    }
    
    var swipeInProgressVc: UIViewController?
    
    override func viewDidLoad() {
        UIPageControl.appearance().backgroundColor = UIColor.clear
        self.dataSource = self
        self.delegate = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    		
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.swipeInProgressVc = pendingViewControllers[0]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.listener?.onPageChange(index: orderedViewControllers.firstIndex(of: self.swipeInProgressVc!)!)
        }
    }
    
    private func newColoredViewController(_ color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(color)Vc")
    }
}

protocol OnPageChangeListener {
    func onPageChange(index: Int)
    func onPageCountChange(count: Int)
}
