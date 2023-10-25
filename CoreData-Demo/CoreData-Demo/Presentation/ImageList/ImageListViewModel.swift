//
//  ViewModel.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import Foundation
import RxSwift
import RxCocoa

struct ImageListViewModel:
	ImageListViewModelInput,
	ImageListViewModelOutput,
	ImageListViewModelType {
	// MARK: - Properties
	let disposeBag = DisposeBag()
	let dependency: RepositoryType
	
	var input: ImageListViewModelInput { return self }
	var output: ImageListViewModelOutput { return self }
	
	private let images$ = BehaviorRelay<[ImageInfo]>(value: [])
	
	// MARK: - Input
	
	func viewWillAppear() {
		fetch()
		bind()
	}
	
	// MARK: - Output
	var images: Driver<[ImageInfo]>
	var indicatorState = BehaviorRelay<IndicatorState>(value: .stop)
	
	// MARK: - Initializers
	init(dependency: RepositoryType = Repository()) {
		self.dependency = dependency
		
		self.images = images$.asDriver(onErrorJustReturn: [])
	}
}

// MARK: - Private Methods
private extension ImageListViewModel {
	func fetch() {
		Task {
			indicatorState.accept(.start)
			await dependency.fetchImages(from: .coreData)
				.observe(on: MainScheduler.instance)
				.subscribe(
					onSuccess: { self.images$.accept($0) }
				)
				.disposed(by: disposeBag)
			indicatorState.accept(.stop)
		}
	}
	
	func bind() { }
}
