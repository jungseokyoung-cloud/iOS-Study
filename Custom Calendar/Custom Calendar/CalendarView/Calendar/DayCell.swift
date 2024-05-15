//
//  DayCell.swift
//  Custom Calendar
//
//  Created by jung on 5/13/24.
//

import UIKit
import SnapKit

final class DayCell: UICollectionViewCell {
	private var type: DateType = .default
	
	override var isSelected: Bool {
		didSet {
			self.setupUI(for: type, isSelected: isSelected)
		}
	}
	
	// MARK: - UI Components
	private let label: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 15)
		
		return label
	}()
	private let circularView = UIView()
	
	// MARK: - Initializers
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - layoutSubviews
	override func layoutSubviews() {
		super.layoutSubviews()
		// ciruclarView를 원형으로 만들기 위한 코드.
		circularView.layer.cornerRadius = self.frame.height / 2
	}
	
	// MARK: - Configure
	func configure(
		_ day: String,
		type: DateType
	) {
		self.label.text = day
		self.type = type
		
		switch type {
			case .default:
				self.isUserInteractionEnabled = true
			case .disabled, .startDate:
				self.isUserInteractionEnabled = false
		}
		
		setupUI(for: type, isSelected: isSelected)
	}
}

// MARK: - UI Methods
private extension DayCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(circularView)
		circularView.addSubview(label)
	}
	
	func setConstraints() {
		label.snp.makeConstraints { $0.center.equalToSuperview() }
		circularView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
}

private extension DayCell {
	func setupUI(for type: DateType, isSelected: Bool) {
		
		label.textColor = textColor(for: type, isSelected: isSelected)
		circularView.backgroundColor = backgroundColor(for: type, isSelected: isSelected)
	}
	
	func textColor(for type: DateType, isSelected: Bool) -> UIColor {
		switch type {
			case .default:
				return isSelected ? .white : .black
			case .disabled:
				return .systemGray5
			case .startDate:
				return .white
		}
	}
	
	func backgroundColor(for type: DateType, isSelected: Bool) -> UIColor {
		switch type {
			case .default:
				return isSelected ? UIColor(red: 0.22, green: 0.75, blue: 0.52, alpha: 1) : .white
			case .disabled:
				return .white
			case .startDate:
				return .systemGray3
		}
	}
}
