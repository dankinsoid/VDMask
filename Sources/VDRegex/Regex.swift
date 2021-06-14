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
	
	public static func +(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex(lhs.value + rhs.value)
	}
	
	public static func |(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex("\(lhs.value)|\(rhs.value)")
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

prefix operator ^
postfix operator +
postfix operator *
postfix operator *?
postfix operator +?
postfix operator *+
postfix operator ++

prefix operator ?=
prefix operator ?!
prefix operator ?<=
prefix operator ?<!

public postfix func +(_ lhs: Regex) -> Regex {
	lhs.repeats
}

public postfix func *(_ lhs: Regex) -> Regex {
	lhs.anyCount
}

public postfix func *?(_ lhs: Regex) -> Regex {
	Regex(lhs.value + "*?")
}

public postfix func +?(_ lhs: Regex) -> Regex {
	Regex(lhs.value + "+?")
}

public postfix func *+(_ lhs: Regex) -> Regex {
	Regex(lhs.value + "*+")
}

public postfix func ++(_ lhs: Regex) -> Regex {
	Regex(lhs.value + "++")
}

public prefix func ^(_ rhs: Regex) -> Regex {
	Regex("^" + rhs.value)
}

public prefix func ^(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	"^" + rhs
}

public prefix func !(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	^rhs
}

public prefix func ?=(_ rhs: Regex) -> Regex {
	Regex("(?=\(rhs.value))")
}

public prefix func ?!(_ rhs: Regex) -> Regex {
	Regex("(?!\(rhs.value))")
}

public prefix func ?<=(_ rhs: Regex) -> Regex {
	Regex("(?<=\(rhs.value))")
}

public prefix func ?<!(_ rhs: Regex) -> Regex {
	Regex("(?<!\(rhs.value))")
}

extension Regex {
	public var ns: NSRegularExpression? {
		try? NSRegularExpression(pattern: value)
	}
}

extension CharacterSet {
	
	public static var regexSpecial: CharacterSet {
		CharacterSet(charactersIn: "[]\\/^$.|?*+(){}")
	}
}

extension StringProtocol {
	
	public func match(_ regex: Regex) -> Bool {
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex.value)
		return emailPredicate.evaluate(with: String(self))
	}
	
	public func replacing(_ regex: Regex, with template: String) -> String {
		regex.ns?.stringByReplacingMatches(in: String(self), options: [], range: NSRange(location: 0, length: count), withTemplate: template) ?? String(self)
	}
}

public func ~=<T: StringProtocol>(lhs: Regex, rhs: T) -> Bool {
	rhs.match(lhs)
}

private extension String {
	var regexShielding: String {
		map { CharacterSet.regexSpecial.contains($0) ? "\\\($0)" : String($0) }.joined()
			.replacingOccurrences(of: "\n", with: "\\n")
	}
}

extension Regex {
	public init(@RegexBuilder _ builder: () -> Regex) {
		self = builder()
	}
}

@resultBuilder
public enum RegexBuilder {
	
	@inlinable
	public static func buildBlock(_ components: Regex...) -> Regex {
		create(from: components)
	}
	
	@inlinable
	public static func buildArray(_ components: [Regex]) -> Regex {
		create(from: components)
	}
	
	@inlinable
	public static func buildEither(first component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildEither(second component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildOptional(_ component: Regex?) -> Regex {
		component ?? create(from: [])
	}
	
	@inlinable
	public static func buildLimitedAvailability(_ component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildExpression(_ expression: Regex) -> Regex {
		expression
	}
	
	@inlinable
	public static func buildExpression(_ expression: [Regex.SymbolsSet]) -> Regex {
		Regex(expression)
	}
	
	@inlinable
	public static func buildExpression(_ string: String) -> Regex {
		.string(string)
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> Int) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> ClosedRange<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> PartialRangeFrom<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> PartialRangeThrough<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func create(from regexes: [Regex]) -> Regex {
		Regex(regexes.map { $0.value }.joined())
	}
}

extension CharacterSet {
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy(contains)
	}
}
