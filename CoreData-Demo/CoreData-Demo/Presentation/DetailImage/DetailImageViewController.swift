//
//  DetailImageViewController.swift
//  CoreData-Demo
//
//  Created by Seok Young Jung on 2023/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailImageViewController: UIViewController {
	// MARK: - Properties
	private let disposeBag = DisposeBag()
	private let viewModel: DetailImageViewModelType
	
	// MARK: - UI Components
	private let imageView = UIImageView()
	
	private let idStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 10
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let authorStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 10
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let idTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 14)
		label.text = "ID"
		
		return label
	}()
	
	private let authorTitleLabel: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 14)
		label.text = "Author"
		
		return label
	}()
	
	private let idLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12)
		label.text = "1"

		return label
	}()
	
	private let authorTextField: UITextField = {
		let textField = UITextField()
		textField.font = .systemFont(ofSize: 12)
		textField.borderStyle = .line
		
		return textField
	}()
	
	private let editButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemGray2
		
		return button
	}()
	
	private let deleteButton: UIButton = {
		let button = UIButton()
		button.setTitle("삭제", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemGray2
		
		return button
	}()
	
	// MARK: - Initializers
	init(viewModel: DetailImageViewModelType) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		imageView.backgroundColor = .red
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.input.viewWillAppear()
	}
}

// MARK: - UI Methods
private extension DetailImageViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubview(imageView)
		view.addSubview(idStackView)
		view.addSubview(authorStackView)
		view.addSubview(editButton)
		view.addSubview(deleteButton)
		view.addSubview(idTitleLabel)
		view.addSubview(idLabel)
		view.addSubview(authorTitleLabel)
		view.addSubview(authorTextField)
	}
	
	func setConstraints() {
		imageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(40)
			make.height.width.equalTo(100)
			make.top.equalToSuperview().offset(100)
		}
		
		idTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(imageView.snp.trailing).offset(25)
			make.centerY.equalTo(imageView).offset(-25)
		}
		
		idLabel.snp.makeConstraints { make in
			make.centerY.equalTo(idTitleLabel)
			make.leading.equalTo(idTitleLabel).offset(60)
		}
		
		authorTitleLabel.snp.makeConstraints { make in
			make.leading.equalTo(idTitleLabel)
			make.centerY.equalTo(imageView).offset(25)
		}
		
		authorTextField.snp.makeConstraints { make in
			make.centerY.equalTo(authorTitleLabel)
			make.leading.equalTo(idLabel)
			make.trailing.equalToSuperview().offset(-30)
			make.height.equalTo(30)
		}
		
		editButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview().offset(-50)
			make.top.equalTo(imageView.snp.bottom).offset(50)
			make.height.equalTo(30)
			make.width.equalTo(70)
		}
		
		deleteButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview().offset(50)
			make.top.height.width.equalTo(editButton)
		}
	}
}

// MARK: - Bind Methods
private extension DetailImageViewController {
	func bind() {
		bindInput()
		bindOutput()
	}
	
	func bindInput() {
		let imageInfo = Observable.combineLatest(
			viewModel.output.id.asObservable(),
			authorTextField.rx.text.orEmpty,
			viewModel.output.image.asObservable()
		)

		editButton.rx.tap
			.withLatestFrom(imageInfo)
			.bind(with: self) { owner, imageInfo in
				owner.viewModel.input.didTapEditButton(id: imageInfo.0, author: imageInfo.1, image: imageInfo.2)
			}
			.disposed(by: disposeBag)
		
		deleteButton.rx.tap
			.withLatestFrom(imageInfo)
			.map { $0.0 }
			.bind(with: self) { owner, id in
				owner.viewModel.input.didTapDeleteButton(at: id)
			}
			.disposed(by: disposeBag)
	}
	
	func bindOutput() {
		viewModel.output.id
			.drive(idLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.output.author
			.drive(authorTextField.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.output.image
			.drive(imageView.rx.image)
			.disposed(by: disposeBag)
		
		viewModel.output.dismiss
			.emit(with: self) { owner, _ in
				owner.navigationController?.popViewController(animated: true)
			}
			.disposed(by: disposeBag)
	}
}
