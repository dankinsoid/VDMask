//
//  File.swift
//
//
//  Created by Данил Войдилов on 04.11.2021.
//

import Foundation

public indirect enum Regex: RawRepresentable, ExpressibleByStringInterpolation, Codable, Equatable, Hashable, ExpressibleByArrayLiteral, CustomStringConvertible {
	case sequence([Regex])
	
	case string(String)
	///()
	case group(Regex.Group, Regex)
	///[]
	case set([Regex.SymbolsSet])
	///`.` matches any character (except for line terminators)
	case any
	///\d
	case digit
	///\D
	case notDigit
	///\s
	case space
	///\S
	case notSpace
	///\w
	case wordChar
	///\W
	case notWordChar
	///\n
	case nextLine
	///\r
	case carriageReturn
	///\b
	case wordEdge
	///\B
	case notWordEdge
	///\G
	case previous
	///^
	case textBegin
	///$
	case textEnd
	///`?`
	case oneOrNone(_ regex: Regex, quantification: Regex.Quantification = .default)
	///`+`
	case oneAndMore(_ regex: Regex, quantification: Regex.Quantification = .default)
	///`*`
	case anyCount(_ regex: Regex, quantification: Regex.Quantification = .default)
	///{n}
	case `repeat`(_ count: Int, _ regex: Regex, quantification: Regex.Quantification = .default)
	///{min,max}
	case repeatIn(_ range: ClosedRange<Int>, _ regex: Regex, quantification: Regex.Quantification = .default)
	///{min,}
	case repeatFrom(_ min: Int, _ regex: Regex, quantification: Regex.Quantification = .default)
	///{,max}
	case repeatTo(_ max: Int, _ regex: Regex, quantification: Regex.Quantification = .default)
	///\number
	case found(_ number: Int)
	///(?<=regex), (?=regex), (?<!regex), (?!regex)
	case look(_ look: Regex.Look, _ regex: Regex)
	///\Qstring\E
	case shielded(_ string: String)
	///(?modifier)
	case modifier(_ modifier: Regex.Modifiers)
	///(?(?=condition)then|else)
	case ifLook(_ look: Regex.Look, _ condition: Regex, then: Regex, `else`: Regex)
	///(?(group)then|else)
	case `if`(group: Int, then: Regex, else: Regex)
	///regex0|regex1
	case or(_ regexes: [Regex])
	///(?#comment)
	case comment(String)
	
	public var rawValue: String {
		switch self {
		case .sequence(let regexes): return regexes.map { $0.rawValue }.joined()
		case .string(let string): return string.regexShielding
		case .group(let group, let regex): return "(\(group.value)\(regex.rawValue))"
		case .set(let array): return "[\(array.map { $0.pattern }.joined())]"
		case .any: return "."
		case .digit: return "\\d"
		case .notDigit: return "\\D"
		case .space: return "\\s"
		case .notSpace: return "\\S"
		case .wordChar: return "\\w"
		case .notWordChar: return "\\W"
		case .nextLine: return "\\n"
		case .carriageReturn: return "\\r"
		case .wordEdge: return "\\b"
		case .notWordEdge: return "\\B"
		case .previous: return "\\G"
		case .textBegin: return "^"
		case .textEnd: return "$"
		case .oneOrNone(let regex, let quantification): return regex.groupedIfNeeded.rawValue + "?" + quantification.rawValue
		case .oneAndMore(let regex, let quantification): return regex.groupedIfNeeded.rawValue + "+" + quantification.rawValue
		case .anyCount(let regex, let quantification): return regex.groupedIfNeeded.rawValue + "*" + quantification.rawValue
		case .repeat(let count, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(count)}" + quantification.rawValue
		case .repeatIn(let range, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(range.lowerBound),\(range.upperBound)}" + quantification.rawValue
		case .repeatFrom(let min, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(min),}" + quantification.rawValue
		case .repeatTo(let max, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{,\(max)}" + quantification.rawValue
		case .found(let i): return "\\\(i)"
		case .look(let look, let regex): return "(\(look.rawValue)\(regex.rawValue))"
		case .shielded(let string): return "\\Q\(string)\\E"
		case .modifier(let modifier): return "(?\(modifier.value))"
		case .ifLook(let look, let condition, let then, let `else`): return "(?(\(look.rawValue)\(condition.rawValue))\(then.rawValue)|\(`else`.rawValue))"
		case .if(let group, let then, let `else`): return "(?\(group)\(then.rawValue)|\(`else`.rawValue))"
		case .or(let regexes): return regexes.map { $0.rawValue }.joined(separator: "|")
		case .comment(let comment): return "(?#\(comment))"
		}
	}
	
	public var description: String {
		rawValue
	}
	
	public init?(rawValue: String) {
		try? self.init(pattern: rawValue)
	}
	
	public init(pattern: String) throws {
		#warning("TODO")
		self = .string("")
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let pattern = try container.decode(String.self)
		do {
			self = try Regex(pattern: pattern)
		} catch {
			throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid pattern \(pattern)", underlyingError: error))
		}
	}
	
	public init(stringLiteral value: String) {
		self = .string(value)
	}
	
	public init(stringInterpolation: DefaultStringInterpolation) {
		self = .string(String(stringInterpolation: stringInterpolation))
	}
	
	public init(arrayLiteral elements: SymbolsSet...) {
		self = .set(elements)
	}
	
	var needBeGrouped: Bool {
		switch self {
		case .sequence(let array):
			if array.count == 1 { return array[0].needBeGrouped }
			return !array.isEmpty
		case .string(let string):
			return string.regexShielding.count > 1
		case .or:
			return true
		case .group, .set, .any, .digit, .notDigit, .space, .notSpace, .wordChar, .notWordChar, .nextLine, .carriageReturn, .wordEdge, .notWordEdge, .previous, .textBegin, .textEnd, .oneOrNone, .oneAndMore, .anyCount, .repeat, .repeatIn, .repeatFrom, .repeatTo, .found, .look, .shielded, .modifier, .ifLook, .if, .comment:
			return false
		}
	}
	
	var groupedIfNeeded: Regex {
		if needBeGrouped {
			return .group(.simple, self)
		}
		return self
	}
	
	public func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}
	
	///(regex)
	public static func group(_ regex: Regex) -> Regex { .group(.simple, regex) }
	///[]
	public static func any(of set: [SymbolsSet]) -> Regex { .set(set) }
	///{min,max}
	public static func `repeat`(_ regex: Regex, quantification: Regex.Quantification = .default) -> Regex { .oneAndMore(regex, quantification: quantification) }
	///{min,max}
	public static func `repeat`(_ range: ClosedRange<Int>, _ regex: Regex, quantification: Regex.Quantification = .default) -> Regex { .repeatIn(range, regex, quantification: quantification) }
	///{min,}
	public static func `repeat`(_ range: PartialRangeFrom<Int>, _ regex: Regex, quantification: Regex.Quantification = .default) -> Regex { .repeatFrom(range.lowerBound, regex, quantification: quantification) }
	///{,max}
	public static func `repeat`(_ range: PartialRangeThrough<Int>, _ regex: Regex, quantification: Regex.Quantification = .default) -> Regex { .repeatTo(range.upperBound, regex, quantification: quantification) }
}
