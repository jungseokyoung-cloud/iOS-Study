//
//  UIViewController+Extension.swift
//  CustomTabBar
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit

public protocol FloatingTabBarPresentable {
	func presentTabBar()
	func dimissTabBar()
}

extension UIViewController {
	func hideTabBar() {
		guard let parent = self.parent as? FloatingTabBarPresentable else { return }
		parent.dimissTabBar()
	}
	
	func showTabBar() {
		guard let parent = self.parent as? FloatingTabBarPresentable else { return }
		parent.presentTabBar()
	}
}
