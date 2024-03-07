//
//  MainViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 2/29/24.
//

import UIKit
import SnapKit
class MainViewController: UIViewController {
	struct Item {
		let text: String
		let viewController: UIViewController
	}
	
	private let dataSource: [Item] = [
		Item(text: "Move", viewController: MoveViewController()),
		Item(text: "Scale", viewController: ScaleViewController()),
		Item(text: "Rotate", viewController: RotateViewController()),
		Item(text: "Shake", viewController: ShakeViewController()),
		Item(text: "Circling", viewController: CirclingViewController()),
		Item(text: "Notification", viewController: NotificationViewContoller()),
		Item(text: "FadeAndScale", viewController: FadeAndScaleOutViewController()),
		Item(text: "CATransition", viewController: CATransitionViewController())
	]
	
	// MARK: - UI Components
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: "MyCell"
		)
		
		return tableView
	}()
	
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		
		setupUI()
	}
}

// MARK: - UI Methods
private extension MainViewController {
	func setupUI() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
		
		var content = cell.defaultContentConfiguration()
		
		content.text = dataSource[indexPath.row].text
		cell.contentConfiguration = content
		cell.selectionStyle = .none
		
		return cell
	}
}

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = dataSource[indexPath.row].viewController
		
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
