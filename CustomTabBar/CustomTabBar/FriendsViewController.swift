//
//  FriendsViewController.swift
//  CustomTabBar
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit

final class FriendsViewController: UIViewController {
	// MARK: UI Property
	private lazy var dismissButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("TabBar Dismiss", for: .normal)
		button.tintColor = .white
		button.backgroundColor = .black
		button.addTarget(
			self,
			action: #selector(dismissButtonDidTap),
			for: .touchUpInside
		)
		
		return button
	}()
	
	private lazy var presentButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("TabBar Present", for: .normal)
		button.tintColor = .white
		button.backgroundColor = .black
		button.addTarget(
			self,
			action: #selector(presentButtonDidTap),
			for: .touchUpInside
		)
		
		return button
	}()
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		print("Friends VC Did Load")
		setupUI()
	}
}

// MARK: UI Setting
private extension FriendsViewController {
	func setupUI() {
		view.backgroundColor = .white
		setupSubviews()
		setConstraints()
	}
	
	func setupSubviews() {
		view.addSubview(presentButton)
		view.addSubview(dismissButton)

	}
	
	func setConstraints() {
		NSLayoutConstraint.activate([
			presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			presentButton.heightAnchor.constraint(equalToConstant: 100),
			presentButton.widthAnchor.constraint(equalToConstant: 200),
			
			dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			dismissButton.topAnchor.constraint(equalTo: presentButton.bottomAnchor, constant: 50),
			dismissButton.heightAnchor.constraint(equalToConstant: 100),
			dismissButton.widthAnchor.constraint(equalToConstant: 200)
		])
	}
}

// MARK: Action
private extension FriendsViewController {
	@objc func presentButtonDidTap() {
		self.showTabBar()
	}
	
	@objc func dismissButtonDidTap() {
		self.hideTabBar()
	}
}
