//
//  Sequence+Extension.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import Foundation

extension Sequence {
		func asyncForEach(
				_ operation: (Element) async throws -> Void
		) async rethrows {
				for element in self {
						try await operation(element)
				}
		}
}
