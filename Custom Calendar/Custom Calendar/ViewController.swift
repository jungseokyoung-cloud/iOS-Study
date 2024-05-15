//
//  ViewController.swift
//  Custom Calendar
//
//  Created by jung on 5/13/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
	let calendarView = CalendarView(startDate: .now)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(calendarView)
		calendarView.delegate = self
		calendarView.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
}

// MARK: - CalendarViewDelegate
extension ViewController: CalendarViewDelegate {
	func didSelect(_ date: Date) {
		print("date: \(date)")
	}
}
