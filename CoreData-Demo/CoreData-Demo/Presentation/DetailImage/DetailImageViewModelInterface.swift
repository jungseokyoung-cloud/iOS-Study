//
//  DetailImageViewModelInterface.swift
//  CoreData-Demo
//
//  Created by Seok Young Jung on 2023/10/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailImageViewModelInput {
	func viewWillAppear()
	func didTapEditButton(id: String, author: String, image: UIImage)
	func didTapDeleteButton(at id: String)
}

protocol DetailImageViewModelOutput {
	var author: Driver<String> { get }
	var id: Driver<String> { get }
	var image: Driver<UIImage> { get }
	var dismiss: Signal<Void> { get }
}

protocol DetailImageViewModelType {
	var disposeBag: DisposeBag { get }
	var dependency: RepositoryType { get }
	
	var input: DetailImageViewModelInput { get }
	var output: DetailImageViewModelOutput { get }
	
	init(dependency: RepositoryType, selectedId: Int)
}
