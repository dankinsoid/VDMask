//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	
	public struct SymbolsSet: ExpressibleByArrayLiteral, Equatable, Hashable, Codable, CustomStringConvertible {
		public var elements: [Element]
		public var isInverted: Bool
		
		public var pattern: String {
			"[\(isInverted ? "^" + inverted.clearString : clearString)]"
		}
		
		private var clearString: String {
			elements.map { $0.pattern }.joined()
		}
		
		public var inverted: SymbolsSet {
			SymbolsSet(elements, isInverted: !isInverted)
		}
		
		public var description: String { pattern }
		
		public init(_ elements: [Element], isInverted: Bool = false) {
			self.elements = elements
			self.isInverted = isInverted
		}
		
		public init() {
			elements = []
			isInverted = false
		}
		
		public init(arrayLiteral elements: Element...) {
			self = SymbolsSet(elements)
		}
		
		public init(_ elements: Element...) {
			self = SymbolsSet(elements)
		}
		
//		public init(stringLiteral value: StringLiteralType) {
//			self = SymbolsSet(value)
//		}
		
		public init(_ string: String) {
			elements = [Element(string)]
			isInverted = false
		}
		
		public init(pattern: String) throws {
			guard pattern.hasPrefix("["), pattern.hasSuffix("]") else {
				throw RegexScanError.stringTooShort
			}
			let string = String(pattern.dropFirst().dropLast())
			if let const = Element.constants[string] {
				self = [const]
			} else {
				var context = SymbolsSetParser.Context(index: string.startIndex)
				try SymbolsSetParser(parseConstants: false).parse(string: string, context: &context)
				if context.index < pattern.endIndex {
					throw ParserError.incorrectPattern
				}
				self = context.set
			}
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let pattern = try container.decode(String.self)
			do {
				self = try SymbolsSet(pattern: pattern)
			} catch {
				throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid regex pattern \(pattern)", underlyingError: error))
			}
		}
		
//		public mutating func formUnion(_ other: __owned Regex.SymbolsSet) {
//			elements = elements + other.elements
//		}
//
//		public func union(_ other: Regex.SymbolsSet) -> SymbolsSet {
//			var result = self
//			result.formUnion(other)
//			return result
//		}

//		public mutating func formIntersection(_ other: Regex.SymbolsSet) {
//			var newRaw: [ClosedRange<Character>] = []
//			defer { _rawValue = newRaw }
//			var i = 0
//			for range in rawValue {
//				while i < other.rawValue.count, other.rawValue[i].upperBound < range.lowerBound {
//					i += 1
//				}
//				while i < other.rawValue.count, other.rawValue[i].upperBound <= range.upperBound {
//					newRaw.append(max(range.lowerBound, other.rawValue[i].lowerBound)...min(range.upperBound, other.rawValue[i].upperBound))
//					i += 1
//				}
//				if i < other.rawValue.count, other.rawValue[i].lowerBound <= range.upperBound {
//					newRaw.append(max(range.lowerBound, other.rawValue[i].lowerBound)...min(range.upperBound, other.rawValue[i].upperBound))
//				}
//				guard i < other.rawValue.count else {	return }
//			}
//		}
//
//		#warning("Optimize")
//		public mutating func formSymmetricDifference(_ other: __owned Regex.SymbolsSet) {
//			self = inverted.intersection(other).union(intersection(other.inverted))
//		}
		
		public func contains(_ character: Character) -> Bool {
			isInverted != elements.contains {
				$0.contains(character)
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			try pattern.encode(to: encoder)
		}
		
//		public static func +(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
//			lhs.union(rhs)
//		}
	}
}

extension Regex.SymbolsSet {
	
	public struct Element: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Equatable, Hashable, CustomStringConvertible {
		public var pattern: String
		public var contains: (Character) -> Bool
		
		public var description: String { pattern }
		
		init(pattern: String, contains: @escaping (Character) -> Bool) {
			self.pattern = pattern
			self.contains = contains
		}
		
		public init(_ value: String) {
			self.init(pattern: value) {
				value.contains($0)
			}
		}
		
		public init(_ array: [Element]) {
			self.init(pattern: array.map({ $0.pattern }).joined()) { char in
				array.contains(where: { $0.contains(char) })
			}
		}
		
		public init(_ elements: Element...) {
			self.init(elements)
		}
		
		public init(stringLiteral value: String) {
			self.init(value)
		}
		
		public func hash(into hasher: inout Hasher) {
			pattern.hash(into: &hasher)
		}
		
		public static func ==(lhs: Regex.SymbolsSet.Element, rhs: Regex.SymbolsSet.Element) -> Bool {
			lhs.pattern == rhs.pattern
		}
		
		public static let latinLetters = Element("A"..."Z", "a"..."z")
		public static let latinUppercase: Element = "A"..."Z"
		public static let latinLowercase: Element = "a"..."z"
		
		///[:alnum:] - Alphanumeric characters, [A-Za-z0-9]
		public static let alphanumeric = Element(pattern: "[:alnum:]") { CharacterSet.decimalDigits.contains($0) || $0.isLetter }
		///[:alpha:] - Alphabetic characters, [A-Za-z]
		public static let alphabetic = Element(pattern: "[:alpha:]") { $0.isLetter }
		///[:blank:] - Space and tab, [ \t]
		public static let blank = Element(pattern: "[:blank:]") { " \t".contains($0) }
		///[:cntrl:] - Control characters, [\x00-\x1F\x7F]
		public static let control = Element(pattern: "[:cntrl:]") { ("\u{00}"..."\u{1F}").contains($0) || $0 == "\u{7F}" }
		///[:digit:] - Digits, [0-9]
		public static let digits = Element(pattern: "[:digit:]") { CharacterSet.decimalDigits.contains($0) }
//		///[:graph:] - Visible characters
//		public static let visible = Element(pattern: "[:graph:]") { $0.isNumber || $0.isLetter }
		///[:lower:] - Lowercase letters, [\x21-\x7E]
		public static let lowercase = Element(pattern: "[:lower:]") { $0.isLowercase }
//		///[:print:] - Visible characters and the space character
//		public static let print: SymbolsSet = [.visible, " "]//["\u{20}"-"\u{7E}"]
		///[:punct:] - Punctuation characters, [!"#$%&'()*+,./:;<=>?@\^_`{|}~-]
		public static let punctuation = Element(pattern: "[:punct:]") { "!\"#$%&'()*+,./:;<=>?@\\^_`{|}~-".contains($0) }
		///[:space:] - Whitespace characters, [ \t\r\n\v\f]
		public static let whitespaces = Element(pattern: "[:space:]") { CharacterSet.whitespacesAndNewlines.contains($0) }
		///[:upper:] - Uppercase letters, [A-Z]
		public static let uppercase = Element(pattern: "[:upper:]") { $0.isUppercase }
		///[:xdigit:] - Hexadecimal digits, [A-Fa-f0-9]
		public static let hex = Element(pattern: "[:xdigit:]") { $0.isHexDigit }
		
		private(set) public static var constants: [String: Element] = [
			"[:alnum:]": .alphanumeric,
			"[:alpha:]": .alphabetic,
			"[:blank:]": .blank,
			"[:cntrl:]": .control,
//			"[:graph:]": .visible,
			"[:lower:]": .lowercase,
//			"[:print:]": .print,
			"[:punct:]": .punctuation,
			"[:space:]": .whitespaces,
			"[:upper:]": .uppercase,
			"[:xdigit:]": .hex
		]
		
		public static var constantsNames: [Element: String] {
			Dictionary(constants.map { ($0.value, $0.key) }, uniquingKeysWith: { _, p in p })
		}
		static var constantsLenghts: Set<Int> { Set(constants.map { $0.key.count }) }
		
		///
		@discardableResult
		public static func addConstant(name: String, containsCharacter: @escaping (Character) -> Bool) -> Element {
			let pattern = "[:\(name):]"
			let result = Element(pattern: pattern, contains: containsCharacter)
			constants[pattern] = result
			return result
		}
	}
}

public func ...(_ lhs: Character, _ rhs: Character) -> Regex.SymbolsSet.Element {
	Regex.SymbolsSet.Element(pattern: lhs.regex + "-" + rhs.regex) {
		(min(lhs, rhs)...max(lhs, rhs) as ClosedRange<Character>).contains($0)
	}
}

//public func -(_ lhs: Character, _ rhs: Character) -> Regex.SymbolsSet.Element {
//	Regex.SymbolsSet(rawValue: [lhs...rhs])
//}

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
	public static var last: Unicode.Scalar { "\u{10FFFF}" }
}

extension Collection where Element == ClosedRange<Character> {
	
	var united: [ClosedRange<Character>] {
		guard count > 1 else { return Array(self) }
		return sorted(by: { $0.lowerBound < $1.lowerBound }).reduce(into: []) { partialResult, range in
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

private extension Character {
	static var nonPrintable: [Character: String] {
		[
			"\0": "\\0",
			"\t": "\\t",
			"\n": "\\n",
			"\u{B}": "\\v",
			"\u{C}": "\\f",
			"\r": "\\r",
			"\\": "\\\\",
			"-": "\\-",
			"]": "\\]"
		]
	}
	
	var regex: String {
		if let nonPrintable = Character.nonPrintable[self] {
			return nonPrintable
		}
		if isASCII {
			return String(self)
		}
		guard let us = unicodeScalars.first else { return String(self) }
		if us.value < 256 {
			return "\\x" + String(format: "%02X", us.value)
		}
		return "\\u" + String(format: "%04X", us.value)
	}
}
