//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	
	public struct SymbolsSet: Equatable, Hashable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
		public var value: String
		
		public init(stringLiteral value: StringLiteralType) {
			self.value = value
		}
		
		public init(arrayLiteral elements: SymbolsSet...) {
			self = SymbolsSet(elements)
		}
		
		public init(_ elements: [SymbolsSet]) {
			value = elements.map { $0.value }.joined()
		}
		
		public init(_ string: String) {
			value = string
		}
		
		public init(integerLiteral value: Int) {
			self.value = "\(value)"
		}
		
		public static func -(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			SymbolsSet("\(lhs.value)-\(rhs.value)")
		}
		
		public static func ...(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			lhs - rhs
		}
		
		public static func +(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			SymbolsSet(lhs.value + rhs.value)
		}
		
		///[:alnum:] - Alphanumeric characters, [A-Za-z0-9]
		public static var alphanumeric: SymbolsSet { "[:alnum:]" }
		///[:alpha:] - Alphabetic characters, [A-Za-z]
		public static var alphabetic: SymbolsSet { "[:alpha:]" }
		///[:blank:] - Space and tab, [ \t]
		public static var blank: SymbolsSet { "[:blank:]" }
		///[:cntrl:] - Control characters, [\x00-\x1F\x7F]
		public static var control: SymbolsSet { "[:cntrl:]" }
		///[:digit:] - Digits, [0-9]
		public static var digits: SymbolsSet { "[:cntrl:]" }
		///[:graph:] - Visible characters, [\x21-\x7E]
		public static var visible: SymbolsSet { "[:graph:]" }
		///[:lower:] - Lowercase letters, [\x21-\x7E]
		public static var lowercase: SymbolsSet { "[:lower:]" }
		///[:print:] - Visible characters and the space character, [\x20-\x7E]
		public static var print: SymbolsSet { "[:print:]" }
		///[:punct:] - Punctuation characters, [][!"#$%&'()*+,./:;<=>?@\^_`{|}~-]
		public static var punctuation: SymbolsSet { "[:punct:]" }
		///[:space:] - Whitespace characters, [ \t\r\n\v\f]
		public static var space: SymbolsSet { "[:space:]" }
		///[:upper:] - Uppercase letters, [A-Z]
		public static var uppercase: SymbolsSet { "[:upper:]" }
		///[:xdigit:] - Hexadecimal digits, [A-Fa-f0-9]
		public static var hex: SymbolsSet { "[:xdigit:]" }
	}
}
