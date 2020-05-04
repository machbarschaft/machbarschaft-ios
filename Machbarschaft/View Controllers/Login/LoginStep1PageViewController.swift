//
//  LoginStep1PageViewController.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 02.05.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class LoginStep1PageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            viewController(withID: "Page1", from: "Login"),
            viewController(withID: "Page2", from: "Login"),
            viewController(withID: "Page3", from: "Login")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension LoginStep1PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
}
