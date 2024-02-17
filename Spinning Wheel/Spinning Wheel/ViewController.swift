//
//  ViewController.swift
//  Spinning Wheel
//
//  Created by jung on 2/17/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
	private let dataSource: [CircularViewModel] = [
		.init(text: "1", color: .red),
		.init(text: "2", color: .blue),
		.init(text: "3", color: .brown),
		.init(text: "4", color: .cyan),
		.init(text: "5", color: .yellow),
		.init(text: "6", color: .green),
		.init(text: "7", color: .gray),
		.init(text: "8", color: .magenta),
		.init(text: "9", color: .orange),
		.init(text: "10", color: .purple)
	]
	
	// MARK: - UI Components
	private let collectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: CircularCollectionViewLayout()
	)
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

private extension ViewController {
	func setupUI() {
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
}
