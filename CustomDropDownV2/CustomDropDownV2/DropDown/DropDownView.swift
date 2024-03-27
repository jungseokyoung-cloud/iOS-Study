//
//  DropDownView.swift
//  CustomDropDownV2
//
//  Created by jung on 3/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DropDownView: UIView {
	private enum DropDownMode {
		case display
		case hide
	}
	
	// MARK: - Properties
	weak var delegate: DropDownDelegate?
	
	/// DropDown을 띄울 Constraint를 적용합니다. default는 anchorView아래입니다.
	private var dropDownConstraints: ((ConstraintMaker) -> Void)?
	
	/// DropDown을 display여부를 확인 및 설정할 수 있습니다.
	var isDisplayed: Bool {
		get {
			dropDownMode == .display
		}
		set {
			if newValue {
				becomeFirstResponder()
			} else {
				resignFirstResponder()
			}
		}
	}
	
	/// DropDownView의 상태를 확인하는 private 변수입니다.
	private var dropDownMode: DropDownMode = .hide

	/// DropDown에 띄울 목록들을 정의합니다.
	var dataSource = [String]() {
		didSet { dropDownTableView.reloadData() }
	}
		
	/// DropDown의 현재 선택된 항목을 알 수 있습니다.
	private(set) var selectedOption: String?

	override var canBecomeFirstResponder: Bool { true }
	
	// MARK: - UI Components
	private let anchorView: UIView
	fileprivate let dropDownTableView = DropDownTableView()
	
	// MARK: - Initializers
	init(anchorView: UIView) {
		self.anchorView = anchorView
		super.init(frame: .zero)
		
		dropDownTableView.dataSource = self
		dropDownTableView.delegate = self
		
		setupUI()
	}
	
	convenience init(anchorView: UIView, selectedOption: String) {
		self.init(anchorView: anchorView)
		self.selectedOption = selectedOption
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UIResponder Methods
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if dropDownMode == .display {
			resignFirstResponder()
		} else {
			becomeFirstResponder()
		}
	}
	
	@discardableResult
	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()

		dropDownMode = .display
		displayDropDown(with: dropDownConstraints)
		return true
	}
	
	@discardableResult
	override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()

		dropDownMode = .hide
		hideDropDown()
		return true
	}
}

// MARK: - UI Method
private extension DropDownView {
	func setupUI() {
		self.addSubview(anchorView)
		anchorView.snp.makeConstraints { $0.edges.equalToSuperview() }
		
		setConstraints {
			$0.leading.trailing.equalTo(self.anchorView)
			$0.top.equalTo(self.anchorView.snp.bottom)
		}
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
	
	/// DropDownList를 hide합니다.
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
		delegate?.dropDown(self, didSelectRowAt: indexPath)
		dropDownTableView.selectRow(at: indexPath)
		resignFirstResponder()
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: DropDownView {
	var selectedOption: ControlEvent<String> {
		let source = base.dropDownTableView.rx.itemSelected.map { base.dataSource[$0.row] }
		
		return ControlEvent(events: source)
	}
}
