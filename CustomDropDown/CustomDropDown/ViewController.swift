//
//  ViewController.swift
//  CustomDropDown
//
//  Created by jung on 10/29/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
	// MARK: - Properties
	private let disposeBag = DisposeBag()
	var dropDownViews: [DropDownView]?
	
	// MARK: - UI Components
	private let dropDownView = DropDownView()
	private let label: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.systemGray2.cgColor
		label.layer.borderWidth = 1
		label.layer.cornerRadius = 12
		
		return label
	}()
	
	private let dropDownButton = DropDownButton(title: "라면", option: .title)
	private let dropDownView2 = DropDownView()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		bind()
		registerDropDrownViews(dropDownView, dropDownView2)
	}
	
	// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard
			let touch = touches.first,
			let hitView = self.view.hitTest(touch.location(in: view), with: event)
		else { return }

		self.hit(at: hitView)
	}
}

// MARK: - UI Methods
private extension ViewController {
	func setupUI() {		
		setViewHierarchy()
		setConstraints()
		setDropDown()
	}
	
	func setViewHierarchy() {
		view.addSubview(label)
		view.addSubview(dropDownView)
		
		view.addSubview(dropDownButton)
		view.addSubview(dropDownView2)
	}
	
	func setConstraints() {
		label.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalTo(200)
			make.height.equalTo(50)
		}
		
		dropDownView.setConstraints { [weak self] make in
			guard let self else { return }
			make.leading.trailing.equalTo(label)
			make.top.equalTo(label.snp.bottom)
		}
		
		dropDownButton.snp.makeConstraints { make in
			make.top.equalTo(label.snp.bottom).offset(80)
			make.leading.trailing.equalTo(label)
		}
		
		dropDownView2.setConstraints { [weak self] make in
			guard let self else { return }
			make.leading.trailing.equalTo(dropDownButton)
			make.top.equalTo(dropDownButton.snp.bottom)
		}
	}
	
	func setDropDown() {
		dropDownView.anchorView = label
		dropDownView.dataSource = ["신라면", "진라면", "참깨라면"]
		
		dropDownView2.anchorView = dropDownButton
		dropDownView2.dataSource = ["신라면", "진라면", "참깨라면", "삼양라면"]
	}
}

// MARK: - Bind Methods
private extension ViewController {
	func bind() {
		dropDownView2.rx.selectedOption
			.map { ($0, .option) }
			.bind(to: dropDownButton.rx.title)
			.disposed(by: disposeBag)
	}
}

// MARK: - DropDownListener
extension ViewController: DropDownListener {
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath) {
		if dropDown === dropDownView {
			label.text = dropDownView.selectedOption
		}
	}
}
