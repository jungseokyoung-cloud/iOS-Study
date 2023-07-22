//
//  ViewController.swift
//  CustomTabBar
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit

class RootTabBarController:
	UIViewController,
	FloatingTabBarPresentable {
	
	private var selectedIndex: Int = 0
	private var tabBarItems: [TabBarButton] = []
	private var viewControllers: [UIViewController] = []
	
	// MARK: UI Property
	private let floatingTabBar: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemGray6
		view.layer.cornerRadius = 20
		
		return view
	}()
	
	private let firstTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "person.3.sequence",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
		)
		
		let button = TabBarButton(title: "친구", image: image)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let secondTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "mail.stack",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
		)
		
		let button = TabBarButton(title: "채팅", image: image)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let thirdTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "person",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
		)
		
		let button = TabBarButton(title: "프로필", image: image)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		self.tabBarItems = [firstTabButton, secondTabButton, thirdTabButton]
		/// Add Tag to TabBarItems
		for (index, item) in tabBarItems.enumerated() {
			item.tag = index
		}
		
		/// Add Action to TabBarItems
		tabBarItems.forEach {
			$0.addTarget(
				self, action:
					#selector(tabBarItemDidTap),
				for: .touchUpInside
			)
		}
		
		/// Register ViewController
		let friendsVc = UINavigationController(rootViewController: FriendsViewController())
		let chattingVc = UINavigationController(rootViewController:ChattingViewController())
		let profileVc = UINavigationController(rootViewController: ProfileViewController())
		
		self.viewControllers = [friendsVc, chattingVc, profileVc]
		
		/// Present first Item ViewController when ViewDidLoad
		attachViewControllerToParent(selectedIndex)
		setupUI()
	}
}

// MARK: UI Setting
private extension RootTabBarController {
	func setupUI() {
		view.backgroundColor = .white
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		view.addSubview(floatingTabBar)
		floatingTabBar.addSubview(firstTabButton)
		floatingTabBar.addSubview(secondTabButton)
		floatingTabBar.addSubview(thirdTabButton)
	}
	
	func setConstraints() {
		NSLayoutConstraint.activate([
			floatingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
			floatingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
			
			floatingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
			floatingTabBar.heightAnchor.constraint(equalToConstant: 60),
			
			firstTabButton.leadingAnchor.constraint(equalTo: floatingTabBar.leadingAnchor, constant: 26),
			firstTabButton.centerYAnchor.constraint(equalTo: floatingTabBar.centerYAnchor),
			
			secondTabButton.centerXAnchor.constraint(equalTo: floatingTabBar.centerXAnchor),
			secondTabButton.bottomAnchor.constraint(equalTo: firstTabButton.bottomAnchor),
			
			thirdTabButton.trailingAnchor.constraint(equalTo: floatingTabBar.trailingAnchor, constant: -21),
			thirdTabButton.centerYAnchor.constraint(equalTo: floatingTabBar.centerYAnchor)
		])
	}
}

// MARK: TabBar Action
private extension RootTabBarController {
	@objc func tabBarItemDidTap(_ button: UIButton) {
		guard self.selectedIndex != button.tag else { return }
		
		removeViewControllerFromParent(selectedIndex)
		attachViewControllerToParent(button.tag)
		
		self.selectedIndex = button.tag
	}
	
	func removeViewControllerFromParent(_ index: Int) {
		tabBarItems[index].buttonIsSelected = false
		
		let previousVC = viewControllers[index]
		previousVC.willMove(toParent: nil)
		previousVC.view.removeFromSuperview()
		previousVC.removeFromParent()
	}
	
	func attachViewControllerToParent(_ index: Int) {
		tabBarItems[index].buttonIsSelected = true
		
		let viewController = viewControllers[index]
		viewController.view.frame = view.frame
		viewController.didMove(toParent: self)
		self.addChild(viewController)
		self.view.addSubview(viewController.view)
		self.view.bringSubviewToFront(floatingTabBar)
	}
}

// MARK: TabBar Show & Hide
extension RootTabBarController {
	public func dimissTabBar() {
		UIView.animate(
			withDuration: 0.3,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }
			
			self.floatingTabBar.frame = CGRect(
				x: self.floatingTabBar.frame.origin.x,
				y: self.view.frame.height + self.view.safeAreaInsets.bottom + 16,
				width: self.floatingTabBar.frame.width,
				height: self.floatingTabBar.frame.height
			)
			self.view.layoutIfNeeded()
		}
	}
	
	public func presentTabBar() {
		UIView.animate(
			withDuration: 0.3,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }
			
			self.floatingTabBar.frame = CGRect(
				x: self.floatingTabBar.frame.origin.x,
				y: self.view.frame.height - floatingTabBar.frame.height - 32,
				width: self.floatingTabBar.frame.width,
				height: self.floatingTabBar.frame.height
			)
			self.view.layoutIfNeeded()
		}
	}
}
