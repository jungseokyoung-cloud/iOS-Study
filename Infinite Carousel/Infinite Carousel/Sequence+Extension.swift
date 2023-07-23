//
//  Sequence+Extension.swift
//  Infinite Carousel
//
//  Created by Seok Young Jung on 2023/07/22.
//

import Foundation

extension Sequence {
		func asyncMap<T>(
				_ transform: (Element) async throws -> T
		) async rethrows -> [T] {
				var values = [T]()

				for element in self {
						try await values.append(transform(element))
				}

				return values
		}
}
