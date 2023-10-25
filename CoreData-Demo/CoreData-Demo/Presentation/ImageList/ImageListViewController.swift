//
//  ViewController.swift
//  CoreData-Demo
//
//  Created by jung on 10/5/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ImageListViewController: UIViewController {
	// MARK: - Properties
	private let disposeBag = DisposeBag()
	private let dependency = ImageListViewModel()
	
	// MARK: - UI Components
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(
			ImageViewCell.self,
			forCellReuseIdentifier: ImageViewCell.identifier
		)
		tableView.rowHeight = 120
		
		return tableView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
		activityIndicator.center = self.view.center
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.style = .large
		activityIndicator.tintColor = .systemGray2

		return activityIndicator
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		dependency.input.viewWillAppear()
	}
}

// MARK: - UI Methods
private extension ImageListViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubview(tableView)
		view.addSubview(activityIndicator)
	}
	
	func setConstraints() {
		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalToSuperview().offset(-150)
		}
	}
}

// MARK: - Bind Method
private extension ImageListViewController {
	func bind() {
		bindInput()
		bindOutput()
		bindTableView()
	}
	
	func bindInput() { }
	
	func bindOutput() {
		dependency.output.images
			.drive(tableView.rx.items(
				cellIdentifier: ImageViewCell.identifier,
				cellType: ImageViewCell.self
			)) { index, item, cell in
				cell.configure(with: item)
			}
			.disposed(by: disposeBag)
		
		dependency.output.indicatorState
			.observe(on: MainScheduler.asyncInstance)
			.bind(with: self) { owner, state in
				switch state {
					case .start:
						owner.activityIndicator.startAnimating()
					case .stop:
						owner.activityIndicator.stopAnimating()
				}
			}
			.disposed(by: disposeBag)
	}
	
	func bindTableView() {
		tableView.rx.itemSelected
			.withLatestFrom(dependency.output.images) { $1[$0.row] }
			.bind(with: self) { owner, imageInfo in
				owner.pushDetailImageViewController(with: imageInfo.id)
			}
			.disposed(by: disposeBag)
	}
	
}

// MARK: - Private Methods
private extension ImageListViewController {
	func pushDetailImageViewController(with id: Int) {
		let detailViewModel = DetailImageViewModel(selectedId: id)
		let detailViewController = DetailImageViewController(viewModel: detailViewModel)
		
		navigationController?.pushViewController(detailViewController, animated: true)
	}
}
