//
//  File.swift
//  
//
//  Created by Данил Войдилов on 31.05.2021.
//

import Foundation

@dynamicMemberLookup
public struct Regex: ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
	public var value: String
	public var description: String { value }
	
	public static subscript(_ regex: SymbolsSet...) -> Regex {
		Regex(regex)
	}
	
	public init() {
		value = ""
	}
	
	public init(_ value: String) {
		self.value = value
	}
	
	public init(_ regex: Regex) {
		self = .group(regex)
	}
	
	public init(stringLiteral value: String) {
		self.value = value
	}
	
	public init(arrayLiteral elements: SymbolsSet...) {
		self.init(elements)
	}
	
	public init(_ elements: [SymbolsSet]) {
		value = "[\(elements.map({ $0.value }).joined())]"
	}
	
	public init(@RegexBuilder _ builder: () -> Regex) {
		self = builder()
	}
	
	public var any: Regex { self + .any }
	public var digit: Regex { self + .digit }
	public var notDigit: Regex { self + .notDigit }
	public var space: Regex { self + .space }
	public var notSpace: Regex { self + .notSpace }
	public var wordChar: Regex { self + .wordChar }
	public var notWordChar: Regex { self + .notWordChar }
	public var nextLine: Regex { self + .nextLine }
	public var carriageReturn: Regex { self + .carriageReturn }
	public var wordEdge: Regex { self + .wordEdge }
	public var notWordEdge: Regex { self + .notWordEdge }
	public var previous: Regex { self + .previous }
	public var textBegin: Regex { self + .textBegin }
	public var textEnd: Regex { self + .textEnd }
	
	public var repeats: Regex { self + Regex("+") }
	public var anyCount: Regex { self + Regex("*") }
	
	public func repeats(_ count: Int) -> Regex {
		self + .repeats(count)
	}
	
	public func repeats(_ range: ClosedRange<Int>) -> Regex {
		self + .repeats(range)
	}
	
	public func repeats(_ range: PartialRangeFrom<Int>) -> Regex {
		self + .repeats(range)
	}
	
	public func repeats(_ range: PartialRangeThrough<Int>) -> Regex {
		self + .repeats(range)
	}
	
	//1-9
	public func found(_ number: Int) -> Regex {
		self + .found(number)
	}
	
	public func look(_ look: Look, _ regex: Regex) -> Regex {
		self + .look(look, regex)
	}
	
	public func look(_ look: Look, @RegexBuilder _ builder: () -> Regex) -> Regex {
		self.look(look, builder())
	}
	
	public func string(_ string: String) -> Regex {
		self + .string(string)
	}
	
	public subscript(_ regex: SymbolsSet...) -> Regex {
		Regex(value + Regex(regex).value)
	}
	
	public subscript(dynamicMember string: String) -> Regex {
		Regex(value + (string.count > 1 ? "(\(string))" : string))
	}
	
	public func callAsFunction(_ input: Regex) -> Regex {
		self + .group(input)
	}
	
	public func callAsFunction(_ input: () -> Int) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> ClosedRange<Int>) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> PartialRangeFrom<Int>) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> PartialRangeThrough<Int>) -> Regex {
		repeats(input())
	}
	
	public struct SymbolsSet: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
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
	}
}

extension Regex {
	public static var any: Regex { Regex(".") }
	public static var digit: Regex { Regex("\\d") }
	public static var notDigit: Regex { Regex("\\D") }
	public static var space: Regex { Regex("\\s") }
	public static var notSpace: Regex { Regex("\\S") }
	public static var wordChar: Regex { Regex("\\w") }
	public static var notWordChar: Regex { Regex("\\W") }
	public static var nextLine: Regex { Regex("\\n") }
	public static var carriageReturn: Regex { Regex("\\r") }
	public static var wordEdge: Regex { Regex("\\b") }
	public static var notWordEdge: Regex { Regex("\\B") }
	public static var previous: Regex { Regex("\\G") }
	public static var textBegin: Regex { Regex("^") }
	public static var textEnd: Regex { Regex("$") }
	
	public static func repeats(_ count: Int) -> Regex {
		Regex("{\(count)}")
	}
	
	public static func repeats(_ range: ClosedRange<Int>) -> Regex {
		Regex("{\(range.lowerBound),\(range.upperBound)}")
	}
	
	public static func repeats(_ range: PartialRangeFrom<Int>) -> Regex {
		Regex("{\(range.lowerBound),}")
	}
	
	public static func repeats(_ range: PartialRangeThrough<Int>) -> Regex {
		Regex("{,\(range.upperBound)}")
	}
	
	//1-9
	public static func found(_ number: Int) -> Regex {
		Regex("\\\(number)")
	}
	
	public static func look(_ look: Look, _ regex: Regex) -> Regex {
		Regex("(\(look.rawValue)\(regex))")
	}
	
	public static func look(_ look: Look, @RegexBuilder _ builder: () -> Regex) -> Regex {
		.look(look, builder())
	}
	
	public static func string(_ string: String) -> Regex {
		Regex((string.count > 1 ? "\\Q\(string)\\E" : string.regexShielding))
	}
	
	public static func group(_ regex: Regex) -> Regex { Regex("(\(regex.value)") }
	public static func group(@RegexBuilder _ builder: () -> Regex) -> Regex { .group(builder()) }
	
	public static func atomGroup(_ regex: Regex) -> Regex { Regex("(?>\(regex.value))") }
	public static func atomGroup(@RegexBuilder _ builder: () -> Regex) -> Regex { .atomGroup(builder()) }
	
//	public static func group(_ regex: Regex) -> Regex { Regex()(regex) }
//	public static func group(@RegexBuilder _ builder: () -> Regex) -> Regex { .group(builder()) }
	
//	public static func any(@ArrayBuilder<SymbolsSet> _ builder: () -> [SymbolsSet]) -> Regex { Regex(builder()) }
	
	public static var email: Regex { Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") }
}

extension Regex {
	public enum Look: String {
		case behind = "?<=", ahead = "?="
		case behindNot = "?<!", aheadNot = "?!"
	}
}

extension Regex {
	public var ns: NSRegularExpression? {
		try? NSRegularExpression(pattern: value)
	}
}
