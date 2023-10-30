//
//  DropDownView.swift
//  CustomDropDown
//
//  Created by jung on 10/29/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DropDownView: UIView {
	// MARK: - Properties
	weak var anchorView: UIView? {
		didSet {
			anchorView?.isUserInteractionEnabled = true
		}
	}
	weak var listener: DropDownListener?
	
	/// DropDown을 띄울 Constraint를 적용합니다.
	private var dropDownConstraints: ((ConstraintMaker) -> Void)?
	
	/// DropDown을 display할지 결정합니다.
	var isDisplayed: Bool = false {
		didSet {
			isDisplayed ? displayDropDown(with: dropDownConstraints) : hideDropDown()
		}
	}

	/// DropDown에 띄울 목록들을 정의합니다.
	var dataSource = [String]() {
		didSet { dropDownTableView.reloadData() }
	}
		
	/// DropDown의 현재 선택된 항목을 알 수 있습니다.
	private(set) var selectedOption: String?
	
	// MARK: - UI Components
	fileprivate let dropDownTableView = DropDownTableView()
	
	// MARK: - Initializers
	init() {
		super.init(frame: .zero)

		dropDownTableView.dataSource = self
		dropDownTableView.delegate = self
	}
	
	convenience public init(selectedOption: String) {
		self.init()
		self.selectedOption = selectedOption
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - DropDown Logic
extension DropDownView {
	/// DropDownList를 보여줍니다.
	func displayDropDown(with constraints: ((ConstraintMaker) -> Void)?) {
		guard let constraints = constraints else { return }
				
		window?.addSubview(dropDownTableView)
		dropDownTableView.snp.makeConstraints(constraints)
	}
	
	/// DropDownList를 숨김니다.
	func hideDropDown() {
		dropDownTableView.removeFromSuperview()
		dropDownTableView.snp.removeConstraints()
	}
	
	func setConstraints(_ closure: @escaping (_ make: ConstraintMaker) -> Void) {
		self.dropDownConstraints = closure
	}
}

// MARK: - UITableViewDataSource
extension DropDownView: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: DropDownCell.identifier,
			for: indexPath
		) as? DropDownCell
		else {
			return UITableViewCell()
		}
		
		/// selectedOption이라면 해당 cell의 textColor가 바뀌도록
		if let selectedOption = self.selectedOption,
			 selectedOption == dataSource[indexPath.row] {
			cell.isSelected = true
		}
		
		cell.configure(with: dataSource[indexPath.row])
		
		return cell
	}
}

// MARK: - UITableViewDelegate
extension DropDownView: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedOption = dataSource[indexPath.row]
		listener?.dropdown(self, didSelectRowAt: indexPath)
		dropDownTableView.selectRow(at: indexPath)
		isDisplayed = false
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: DropDownView {
	var selectedOption: ControlEvent<String> {
		let source = base.dropDownTableView.rx.itemSelected.map { base.dataSource[$0.row] }
		
		return ControlEvent(events: source)
	}
}
