//
//  ViewController.swift
//  Infinite Carousel
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
	private let viewModel = ViewModel()
	private let disposeBag = DisposeBag()
	private var imagesCount: Int = 0
	
	// MARK: UI Property
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .horizontal
		
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = .systemGray6
		collectionView.layer.cornerRadius = 4
		collectionView.isPagingEnabled = true
		collectionView.register(
			UICollectionViewCell.self,
			forCellWithReuseIdentifier: "Cell"
		)
		
		return collectionView
	}()
	
	private let pageControl: UIPageControl = {
		let pageControl = UIPageControl()
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		
		return pageControl
	}()
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		setupUI()
		
		Task { [weak self] in
			await self?.viewModel.input.viewDidLoad()
			self?.scrollToPageAt(1)
		}
	}
}

// MARK: UI Setting
private extension ViewController {
	func setupUI() {
		view.backgroundColor = .white
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	func setupSubviews() {
		view.addSubview(collectionView)
		view.addSubview(pageControl)
	}
	
	func setConstraints() {
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			collectionView.heightAnchor.constraint(equalToConstant: 200),
			
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
		])
	}
}

// MARK: Bind
private extension ViewController {
	func bind() {
		imagesCount = 3
		/// take Image Count
		viewModel.output.images
			.map { $0.count }
			.drive(with: self) { owner, count in
				owner.imagesCount = count
				owner.pageControl.numberOfPages = count
			}
			.disposed(by: disposeBag)
		
		viewModel.output.images
			.map { images in
				guard
					let first = images.first,
					let last = images.last
				else {
					return images
				}
				var appendItems = images
				/// Add last Image to First, Add first Image to Last
				appendItems.insert(last, at: 0)
				appendItems.append(first)
				
				return appendItems
			}
			.drive(collectionView.rx.items(
				cellIdentifier: "Cell",
				cellType: UICollectionViewCell.self
			)) { (_, item, cell) in
				cell.backgroundView = UIImageView(image: item)
			}
			.disposed(by: disposeBag)
		
		collectionView.rx.didEndDecelerating
			.withUnretained(self)
			.bind(with: self) { owner, _ in
				/// Move Page when page in Boundary
				owner.movePageWhenBoundary()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(
			width: self.collectionView.frame.width,
			height: self.collectionView.frame.height
		)
	}
}

// MARK: Infinite Carousel Logic
extension ViewController {
	func movePageWhenBoundary() {
		var page = Int(collectionView.contentOffset.x / collectionView.frame.width)
		
		if page == 0 {
			scrollToPageAt(imagesCount)
			page = imagesCount
		} else if page == imagesCount + 1 {
			scrollToPageAt(1)
			page = 1
		}
		self.pageControl.currentPage = page - 1
	}
	
	func scrollToPageAt(_ index: Int) {
		guard imagesCount >= index else { return }
		
		DispatchQueue.main.async {
			self.collectionView.scrollToItem(
				at: IndexPath(item: index, section: 0),
				at: .right,
				animated: false
			)
		}
	}
}
