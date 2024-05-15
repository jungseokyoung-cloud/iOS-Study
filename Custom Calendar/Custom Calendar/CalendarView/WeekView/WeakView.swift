//
//  WeakView.swift
//  Custom Calendar
//
//  Created by jung on 5/13/24.
//

import UIKit
import SnapKit

final class WeekView: UIStackView {
	private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
	
	// MARK: - Initalizers
	init(spacing: CGFloat = 0) {
		super.init(frame: .zero)
		axis = .horizontal
		alignment = .center
		distribution = .fillEqually
		self.spacing = spacing
		setupUI()
	}
	
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Methods
private extension WeekView {
	func setupUI() {
		setViewHierarchy()
	}
	
	func setViewHierarchy() {
		daysOfWeek.forEach { addArrangedSubview(label($0)) }
		
		self.arrangedSubviews.forEach {
			$0.snp.makeConstraints {
				$0.width.equalTo(14)
			}
		}
	}
}

// MARK: - Private Methods
private extension WeekView {
	func label(_ text: String) -> UILabel {
		let label = UILabel()
		
		label.text = text
		label.textColor = .systemGray
		label.font = .systemFont(ofSize: 14)
		
		return label
	}
}
