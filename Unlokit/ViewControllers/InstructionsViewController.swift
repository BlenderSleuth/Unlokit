//
//  InstructionsViewController.swift
//  Unlokit
//
//  Created by Ben Sutherland on 18/2/17.
//  Copyright © 2017 blendersleuthdev. All rights reserved.
//

import UIKit

class InstructionsPageViewController: UIPageViewController {

	let imageNames = ["Welcome", "TheKey", "Blocks", "Tools", "OtherObjects"]

	var currentIndex = 0

	var pageControl: UIPageControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		dataSource = self
		delegate = self

		pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
		pageControl.numberOfPages = imageNames.count
		view.addSubview(pageControl)
	}

	// To only run it once, doesn't work in viewDidLoad
	var first = false
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if !first {
			if let vc = viewControllerAt(index: 0) {
				setViewControllers([vc],
				                   direction: .forward,
				                   animated: true,
				                   completion: nil)
			}
			first = true
		}
	}

	func viewControllerAt(index: Int) -> InstructionPageContentViewController? {
		if imageNames.count == 0 || index >= imageNames.count {
			return nil
		}

		let vc = storyboard?.instantiateViewController(withIdentifier: "InstructionPageContentViewController") as! InstructionPageContentViewController
		vc.imageFile = imageNames[index]
		vc.pageIndex = index

		return vc
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
}

// Extension for datasource and delegate
extension InstructionsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		var index = (viewController as! InstructionPageContentViewController).pageIndex

		if index == 0 {
			return nil
		}

		index -= 1

		currentIndex = index

		return viewControllerAt(index: index)
	}
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = (viewController as! InstructionPageContentViewController).pageIndex

		if index == NSNotFound {
			return nil
		}

		index += 1

		currentIndex = index

		if index == imageNames.count {
			return nil
		}

		return viewControllerAt(index: index)
	}

	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		let pageContentView = pendingViewControllers[0] as! InstructionPageContentViewController
		pageControl.currentPage = pageContentView.pageIndex
	}

	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if !completed {
			let pageContentView = previousViewControllers[0] as! InstructionPageContentViewController
			pageControl.currentPage = pageContentView.pageIndex
		}
	}
}
