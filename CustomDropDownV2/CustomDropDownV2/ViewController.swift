//
//  ViewController.swift
//  CustomDropDownV2
//
//  Created by jung on 3/26/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
	// MARK: - Properties
	private let dataSource = ["삼양라면", "신라면", "참깨라면", "열라면", "왕뚜껑"]
	
	// MARK: - UI Components
	private let dropDownButton = DropDownButton(title: "선택해주세요", option: .title)
	private lazy var dropDownView = DropDownView(anchorView: dropDownButton)
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		dropDownView.dataSource = dataSource
		dropDownView.delegate = self
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
}

// MARK: - UI Methods
private extension ViewController {
	func setupUI() { 
		setViewHierarchy()
		setConstrations()
	}
	
	func setViewHierarchy() { 
		view.addSubview(dropDownView)
	}
	
	func setConstrations() {
		dropDownView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(44)
		}
	}
}

// MARK: - DropDownViewDelegate
extension ViewController: DropDownDelegate {
	func dropDown(_ dropDownView: DropDownView, didSelectRowAt indexPath: IndexPath) {
		let title = dropDownView.dataSource[indexPath.row]
		dropDownButton.setTitle(title, for: .option)
			}
}
