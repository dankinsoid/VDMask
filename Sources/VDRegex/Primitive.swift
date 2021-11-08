//
//  File.swift
//
//
//  Created by Данил Войдилов on 04.11.2021.
//

import Foundation

indirect enum _Regex: RawRepresentable, ExpressibleByStringInterpolation, Codable {
	case sequence([_Regex])
	case string(String)
	///()
	case group(Regex.Group, _Regex)
	///[]
	case symbolsSet([Regex.SymbolsSet])
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
	case oneOrNone(_ regex: _Regex, quantification: Regex.Quantification = .default)
	///`+`
	case oneAndMore(_ regex: _Regex, quantification: Regex.Quantification = .default)
	///`*`
	case anyCount(_ regex: _Regex, quantification: Regex.Quantification = .default)
	///{n}
	case count(_ count: Int, _ regex: _Regex, _ quantification: Regex.Quantification = .default)
	///{min,max}
	case countRange(_ range: ClosedRange<Int>, _ regex: _Regex, _ quantification: Regex.Quantification = .default)
	///{min,}
	case countFrom(_ min: Int, _ regex: _Regex, _ quantification: Regex.Quantification = .default)
	///{,max}
	case countTo(_ max: Int, _ regex: _Regex, _ quantification: Regex.Quantification = .default)
	///\number
	case found(_ number: Int)
	///(?<=regex), (?=regex), (?<!regex), (?!regex)
	case look(_ look: Regex.Look, _ regex: _Regex)
	///\Qstring\E
	case shielded(_ string: String)
	///(?modifier)
	case modifier(_ modifier: Regex.Modifiers)
	///(?(?=condition)then|else)
	case ifLook(_ look: Regex.Look, _ condition: _Regex, then: _Regex, `else`: _Regex)
	///(?(group)then|else)
	case `if`(group: Int, then: _Regex, else: _Regex)
	///regex0|regex1
	case or(_ regexes: [_Regex])
	///(?#comment)
	case comment(String)
	
	var rawValue: String {
		switch self {
		case .sequence(let regexes): return regexes.map { $0.rawValue }.joined()
		case .string(let string): return string.regexShielding
		case .group(let group, let regex): return "(\(group.value)\(regex.rawValue))"
		case .symbolsSet(let array): return "[\(array.map { $0.value }.joined())]"
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
		case .count(let count, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(count)}" + quantification.rawValue
		case .countRange(let range, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(range.lowerBound),\(range.upperBound)}" + quantification.rawValue
		case .countFrom(let min, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{\(min),}" + quantification.rawValue
		case .countTo(let max, let regex, let quantification): return regex.groupedIfNeeded.rawValue + "{,\(max)}" + quantification.rawValue
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
	
	init?(rawValue: String) {
		try? self.init(pattern: rawValue)
	}
	
	init(pattern: String) throws {
		#warning("TODO")
		self = .string("")
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let pattern = try container.decode(String.self)
		do {
			self = try _Regex(pattern: pattern)
		} catch {
			throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid pattern \(pattern)", underlyingError: error))
		}
	}
	
	init(stringLiteral value: String) {
		self = .string(value)
	}
	
	init(stringInterpolation: DefaultStringInterpolation) {
		self = .string(String(stringInterpolation: stringInterpolation))
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
		case .group, .symbolsSet, .any, .digit, .notDigit, .space, .notSpace, .wordChar, .notWordChar, .nextLine, .carriageReturn, .wordEdge, .notWordEdge, .previous, .textBegin, .textEnd, .oneOrNone, .oneAndMore, .anyCount, .count, .countRange, .countFrom, .countTo, .found, .look, .shielded, .modifier, .ifLook, .if:
			return false
		}
	}
	
	var groupedIfNeeded: _Regex {
		if needBeGrouped {
			return .group(.simple, self)
		}
		return self
	}
	
	func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}
	
	///(regex)
	static func group(_ regex: _Regex) -> _Regex { .group(.simple, regex) }
	///{min,max}
	static func count(_ range: ClosedRange<Int>, _ regex: _Regex, quantification: Regex.Quantification = .default) -> _Regex { .countRange(range, regex, quantification) }
	///{min,}
	static func count(_ range: PartialRangeFrom<Int>, _ regex: _Regex, quantification: Regex.Quantification = .default) -> _Regex { .countFrom(range.lowerBound, regex, quantification) }
	///{,max}
	static func count(_ range: PartialRangeThrough<Int>, _ regex: _Regex, quantification: Regex.Quantification = .default) -> _Regex { .countTo(range.upperBound, regex, quantification) }
}
