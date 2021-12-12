//
//  File.swift
//
//
//  Created by Данил Войдилов on 04.11.2021.
//

import Foundation

public struct Regex: ExpressibleByStringInterpolation, Codable, Equatable, Hashable, ExpressibleByArrayLiteral, CustomStringConvertible {
	var elements: [Element]
	
//	case string(String)
//	///()
//	case group(Regex.Group, Regex)
//	///[]
//	case set(Regex.SymbolsSet)
//	///`.` matches any character (except for line terminators)
//	case any
//	///\d
//	case digit
//	///\D
//	case notDigit
//	///\s
//	case space
//	///\S
//	case notSpace
//	///\w
//	case wordChar
//	///\W
//	case notWordChar
//	///\n
//	case nextLine
//	///\r
//	case carriageReturn
//	///\b
//	case wordEdge
//	///\B
//	case notWordEdge
//	///\G
//	case previous
//	///^
//	case textBegin
//	///$
//	case textEnd
//	///`?`
//	case oneOrNone(_ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///`+`
//	case oneAndMore(_ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///`*`
//	case anyCount(_ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///{n}
//	case `repeat`(_ count: Int, _ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///{min,max}
//	case repeatIn(_ range: ClosedRange<Int>, _ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///{min,}
//	case repeatFrom(_ min: Int, _ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///{,max}
//	case repeatTo(_ max: Int, _ regex: Regex, quantifierType: Regex.QuantifierType = .default)
//	///\number
//	case found(_ number: Int)
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	case look(_ look: Regex.Look, _ regex: Regex)
//	///\Qstring\E
//	case shielded(_ string: String)
//	///(?modifier)
//	case modifier(_ modifier: Regex.Modifiers)
//	///(?(?=condition)then|else)
//	case ifLook(_ look: Regex.Look, _ condition: Regex, then: Regex, `else`: Regex)
//	///(?(group)then|else)
//	case `if`(group: Int, then: Regex, else: Regex)
//	///regex0|regex1
//	case or(_ regexes: [Regex])
//	///(?#comment)
//	case comment(String)
	
	public var pattern: String {
		elements.map { $0.pattern }.joined()
//		switch self {
//		case .sequence(let regexes): return regexes.map { $0.rawValue }.joined()
//		case .string(let string): return string.regexShielding
//		case .group(let group, let regex): return "(\(group.value)\(regex.rawValue))"
//		case .set(let array): return array.pattern
//		case .any: return "."
//		case .digit: return "\\d"
//		case .notDigit: return "\\D"
//		case .space: return "\\s"
//		case .notSpace: return "\\S"
//		case .wordChar: return "\\w"
//		case .notWordChar: return "\\W"
//		case .nextLine: return "\\n"
//		case .carriageReturn: return "\\r"
//		case .wordEdge: return "\\b"
//		case .notWordEdge: return "\\B"
//		case .previous: return "\\G"
//		case .textBegin: return "^"
//		case .textEnd: return "$"
//		case .oneOrNone(let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "?" + quantifierType.rawValue
//		case .oneAndMore(let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "+" + quantifierType.rawValue
//		case .anyCount(let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "*" + quantifierType.rawValue
//		case .repeat(let count, let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "{\(count)}" + quantifierType.rawValue
//		case .repeatIn(let range, let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "{\(range.lowerBound),\(range.upperBound)}" + quantifierType.rawValue
//		case .repeatFrom(let min, let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "{\(min),}" + quantifierType.rawValue
//		case .repeatTo(let max, let regex, let quantifierType): return regex.groupedIfNeeded.rawValue + "{,\(max)}" + quantifierType.rawValue
//		case .found(let i): return "\\\(i)"
//		case .look(let look, let regex): return "(\(look.rawValue)\(regex.rawValue))"
//		case .shielded(let string): return "\\Q\(string)\\E"
//		case .modifier(let modifier): return "(?\(modifier.pattern))"
//		case .ifLook(let look, let condition, let then, let `else`): return "(?(\(look.rawValue)\(condition.rawValue))\(then.rawValue)|\(`else`.rawValue))"
//		case .if(let group, let then, let `else`): return "(?\(group)\(then.rawValue)|\(`else`.rawValue))"
//		case .or(let regexes): return regexes.map { $0.rawValue }.joined(separator: "|")
//		case .comment(let comment): return "(?#\(comment))"
//		}
	}
	
	public var description: String {
		pattern
	}
	
	init(elements: [Element]) {
		self.elements = elements
	}
	
	public init(pattern: String) throws {
		#warning("TODO")
		self = .string("")
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let pattern = try container.decode(String.self)
		do {
			self = try VDRegex.Regex(pattern: pattern)
		} catch {
			throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid pattern \(pattern)", underlyingError: error))
		}
	}
	
	public init(stringLiteral value: String) {
		self = .string(value)
	}
	
	public init(stringInterpolation: StringInterpolation) {
		self = stringInterpolation.regex
	}
	
	public init(arrayLiteral elements: SymbolsSet.Element...) {
		self = .set(SymbolsSet(elements))
	}
	
	//	var groupedIfNeeded: Regex {
	//		if needBeGrouped {
	//			return .group(.simple, self)
	//		}
	//		return self
	//	}
	
//	var needBeGrouped: Bool {
//		switch self {
//		case .sequence(let array):
//			if array.count == 1 { return array[0].needBeGrouped }
//			return !array.isEmpty
//		case .string(let string):
//			return string.regexShielding.count > 1
//		case .or:
//			return true
//		case .group, .set, .any, .digit, .notDigit, .space, .notSpace, .wordChar, .notWordChar, .nextLine, .carriageReturn, .wordEdge, .notWordEdge, .previous, .textBegin, .textEnd, .oneOrNone, .oneAndMore, .anyCount, .repeat, .repeatIn, .repeatFrom, .repeatTo, .found, .look, .shielded, .modifier, .ifLook, .if, .comment:
//			return false
//		}
//	}
	
	public func encode(to encoder: Encoder) throws {
		try pattern.encode(to: encoder)
	}
	
	public func hash(into hasher: inout Hasher) {
		pattern.hash(into: &hasher)
	}
	
//	///(regex)
//	public static func group(_ regex: Regex) -> Regex { .group(.simple, regex) }
//	///[]
//	public static func any(of set: SymbolsSet) -> Regex { .set(set) }
//	///{min,max}
//	public static func `repeat`(_ regex: Regex, quantifierType: Regex.QuantifierType = .default) -> Regex { .oneAndMore(regex, quantifierType: quantifierType) }
//	///{min,max}
//	public static func `repeat`(_ range: ClosedRange<Int>, _ regex: Regex, quantifierType: Regex.QuantifierType = .default) -> Regex { .repeatIn(range, regex, quantifierType: quantifierType) }
//	///{min,}
//	public static func `repeat`(_ range: PartialRangeFrom<Int>, _ regex: Regex, quantifierType: Regex.QuantifierType = .default) -> Regex { .repeatFrom(range.lowerBound, regex, quantifierType: quantifierType) }
//	///{,max}
//	public static func `repeat`(_ range: PartialRangeThrough<Int>, _ regex: Regex, quantifierType: Regex.QuantifierType = .default) -> Regex { .repeatTo(range.upperBound, regex, quantifierType: quantifierType) }
}
