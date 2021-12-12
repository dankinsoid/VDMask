//
//  File.swift
//  
//
//  Created by Данил Войдилов on 12.12.2021.
//

import Foundation

public protocol RegexType {
	var pattern: String { get }
	init(pattern: String, index: inout String.Index) throws
	func scan(string: String, context: inout RegexScanContext) throws
}

extension RegexType {
	var element: Regex.Element {
		Regex.Element(pattern: pattern, scan: scan)
	}
}

extension Regex {
	
	init<R: RegexType>(regex: R) {
		self.init(elements: [regex.element])
	}
	
	public static func extend<R: RegexType>(with regex: R) {
		regexes.insert({ try .init(regex: R.init(pattern: $0, index: &$1)) }, at: 0)
	}
	
	static var regexes: [(String, inout String.Index) throws -> Regex] = [
		{ try .init(regex: SymbolsSet(pattern: $0, index: &$1)) },
		{ try .init(regex: RegexString(pattern: $0, index: &$1)) }
	]
	
	struct Element: Equatable, Hashable {
		var pattern: String
		var scan: (_ string: String, _ context: inout RegexScanContext) throws -> Void
		
		func hash(into hasher: inout Hasher) {
			pattern.hash(into: &hasher)
		}
		
		static func ==(_ lhs: Element, _ rhs: Element) -> Bool {
			lhs.pattern == rhs.pattern
		}
	}
}
