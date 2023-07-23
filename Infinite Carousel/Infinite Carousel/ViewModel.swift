//
//  ViewModel.swift
//  Infinite Carousel
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelInput {
	func viewDidLoad() async
}

protocol ViewModelOutput {
	var images: Driver<[UIImage?]> { get }
}

protocol ViewModelType {
	var dependency: ImageRepositoryType { get }
	var disposeBag: DisposeBag { get }
	
	var input: ViewModelInput { get }
	var output: ViewModelOutput { get }
	
	init(dependency: ImageRepositoryType)
}

final class ViewModel:
	ViewModelInput,
	ViewModelOutput,
	ViewModelType {
	let dependency: ImageRepositoryType
	let disposeBag: DisposeBag
	
	var images: Driver<[UIImage?]>
	var images$ = BehaviorSubject<[UIImage?]>(value: [])
	
	var input: ViewModelInput { return self }
	var output: ViewModelOutput { return self }
	
	init(dependency: ImageRepositoryType = ImageRepository()) {
		self.dependency = dependency
		self.disposeBag = DisposeBag()
		self.images = images$
			.skip(1)
			.asDriver(onErrorJustReturn: [])
	}
	
	func viewDidLoad() async {
		guard let value = try? await dependency.fetchImages(3).value else { return }
		images$.onNext(value)
	}
}
