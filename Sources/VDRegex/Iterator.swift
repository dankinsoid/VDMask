//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.11.2021.
//

import Foundation

extension Regex {
//https://github.com/eneko/RegEx
//	public final class Iterator: IteratorProtocol {
//		let regex: Regex
//		let string: String
//		var current: Regex.Match?
//
//		init(regex: Regex, string: String) {
//			self.regex = regex
//			self.string = string
//			current = regex.firstMatch(in: string)
//		}
//
//		public func next() -> Regex.Match? {
//			defer {
//				current = current.flatMap {
//					let index = $0.ranges[0]?.upperBound
//					return self.regex.firstMatch(in: self.string, from: index)
//				}
//			}
//			return current
//		}
//	}
//
//	public func iterator(for string: String) -> Iterator {
//		Iterator(regex: self, string: string)
//	}
}
