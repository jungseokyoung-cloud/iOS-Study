//
//  DetailImageViewModel.swift
//  CoreData-Demo
//
//  Created by Seok Young Jung on 2023/10/24.
//

import UIKit
import RxSwift
import RxCocoa

struct DetailImageViewModel:
	DetailImageViewModelInput,
	DetailImageViewModelOutput,
	DetailImageViewModelType {
	// MARK: - Properties
	let disposeBag = DisposeBag()
	let dependency: RepositoryType
	let selectedId: Int
	
	var input: DetailImageViewModelInput { return self }
	var output: DetailImageViewModelOutput { return self }
	
	private let imageInfo = BehaviorRelay<ImageInfo>(value: .defaultInfo)
	private let dismiss$ = PublishRelay<Void>()
	
	// MARK: - Input
	func viewWillAppear() {
		fetch()
	}
	
	func didTapEditButton(id: String, author: String, image: UIImage) {
		let imageInfo = ImageInfo(id: Int(id) ?? 0, author: author, image: image)
		
		dependency.updateCoreData(from: selectedId, to: imageInfo)
		dismiss$.accept(())
	}
	
	func didTapDeleteButton(at id: String) {
		dependency.deleteCoreData(for: Int(id) ?? 0)
		
		dismiss$.accept(())
	}
	
	// MARK: - Output
	var author: Driver<String>
	var id: Driver<String>
	var image: Driver<UIImage>
	var dismiss: Signal<Void>
	
	// MARK: - Initializers
	init(dependency: RepositoryType = Repository(), selectedId: Int) {
		self.dependency = dependency
		self.selectedId = selectedId
		
		self.id = imageInfo.asDriver().map { "\($0.id)" }
		self.author = imageInfo.asDriver().map { $0.author }
		self.image = imageInfo.asDriver().map { $0.image }
		self.dismiss = dismiss$.asSignal()
	}
}

// MARK: - Private Methods
private extension DetailImageViewModel {
	func fetch() {
		Task {
			await dependency.fetchImages(from: .coreData)
				.observe(on: MainScheduler.instance)
				.subscribe(
					onSuccess: { imageInfoList in
						let imageInfo = imageInfoList
							.filter { $0.id == self.selectedId }
							.first ?? .defaultInfo
						self.imageInfo.accept(imageInfo)
					}
				)
				.disposed(by: disposeBag)
		}
	}
}
