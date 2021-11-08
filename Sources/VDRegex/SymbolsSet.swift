//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	
	public struct SymbolsSet: OptionSet, Equatable, Hashable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
		public var rawValue: Set<ClosedRange<Character>>
		
		public init(rawValue: Set<ClosedRange<Character>>) {
			self.rawValue = rawValue
		}
		
		public init() {
			rawValue = []
		}
		
		public mutating func formUnion(_ other: __owned Regex.SymbolsSet) {
			rawValue = Set(rawValue.union(other.rawValue).united)
		}
		
		public mutating func formIntersection(_ other: Regex.SymbolsSet) {
			
		}
		
		public mutating func formSymmetricDifference(_ other: __owned Regex.SymbolsSet) {
			
		}
		
		public var value: String {
			"[" + rawValue.map {
				$0.lowerBound == $0.upperBound ? "\($0.lowerBound)" : "\($0.lowerBound)-\($0.upperBound)"
			}
			.joined() + "]"
		}
		
		public init(stringLiteral value: StringLiteralType) {
			self = SymbolsSet(value)
		}
		
		public init(_ elements: [SymbolsSet]) {
			self = elements.reduce([]) { $0.union($1) }
		}
		
		public init(_ string: String) {
			rawValue = Set(string.map { $0...$0 })
		}
		
		public func contains(_ character: Character) -> Bool {
			rawValue.contains {
				$0.contains(character)
			}
		}
		
		public static func +(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			lhs.union(rhs)
		}
		
		public var inverted: SymbolsSet {
			SymbolsSet(
				rawValue: Set(
					rawValue.united.reduce(into: [Character.first...Character.last]) { result, range in
						let i = result.count - 1
						if let next = range.upperBound.next {
							result.append(next...result[result.count - 1].upperBound)
						}
						if let prev = range.lowerBound.prev {
							result[i] = result[i].lowerBound...prev
						} else {
							result.removeLast()
						}
					}
				)
			)
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

public func -(_ lhs: Character, _ rhs: Character) -> Regex.SymbolsSet {
	Regex.SymbolsSet(rawValue: [lhs...rhs])
}

public prefix func ^(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	rhs.inverted
}

extension Character {
	static var first: Character { Character(Unicode.Scalar.first) }
	static var last: Character { Character(Unicode.Scalar.last) }
	
	var prev: Character? {
		unicodeScalars.first.flatMap { $0.value > 0 ? UnicodeScalar($0.value - 1).map { Character($0) } : nil }
	}
	var next: Character? {
		unicodeScalars.first.flatMap { UnicodeScalar($0.value + 1).map { Character($0) } }
	}
}

extension Unicode.Scalar {
	public static var first: Unicode.Scalar { Unicode.Scalar(0) }
	public static var last: Unicode.Scalar { "\u{0010FFFF}" }
}

extension Collection where Element == ClosedRange<Character> {
	
	var united: [ClosedRange<Character>] {
		sorted(by: { $0.lowerBound < $1.lowerBound }).reduce(into: []) { partialResult, range in
			if let upper = partialResult.last?.upperBound, upper >= range.lowerBound {
				if range.upperBound > upper {
					partialResult[partialResult.count - 1] = partialResult[partialResult.count - 1].lowerBound...range.upperBound
				}
			} else {
				partialResult.append(range)
			}
		}
	}
}
