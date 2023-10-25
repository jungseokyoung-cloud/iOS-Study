//
//  ViewModelInterface.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import UIKit
import RxSwift
import RxCocoa

enum IndicatorState {
	case start, stop
}

protocol ImageListViewModelInput {
	func viewWillAppear()
}

protocol ImageListViewModelOutput {
	var images: Driver<[ImageInfo]> { get set }
	var indicatorState: BehaviorRelay<IndicatorState> { get }
}

protocol ImageListViewModelType {
	var disposeBag: DisposeBag { get }
	var dependency: RepositoryType { get }
	
	var input: ImageListViewModelInput { get }
	var output: ImageListViewModelOutput { get }
	
	init(dependency: RepositoryType)
}
