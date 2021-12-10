//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

//extension Regex {
//	
//	///[regex]
//	public static subscript(_ regex: SymbolsSet...) -> Regex {
//		Regex(regex)
//	}
//
//	///(regex)
//	public init(group: Group = .simple, _ regex: Regex) {
//		self = .group(group, regex)
//	}
//
//	///[symbols]
//	public init(_ elements: [SymbolsSet]) {
//		self = .symbols(elements)
//	}
//
//	///`.`
//	public static var any: Regex { Regex(".") }
//	///\d
//	public static var digit: Regex { Regex("\\d") }
//	///\D
//	public static var notDigit: Regex { Regex("\\D") }
//	///\s
//	public static var space: Regex { Regex("\\s") }
//	///\S
//	public static var notSpace: Regex { Regex("\\S") }
//	///\w
//	public static var wordChar: Regex { Regex("\\w") }
//	///\W
//	public static var notWordChar: Regex { Regex("\\W") }
//	///\n
//	public static var nextLine: Regex { Regex("\\n") }
//	///\r
//	public static var carriageReturn: Regex { Regex("\\r") }
//	///\b
//	public static var wordEdge: Regex { Regex("\\b") }
//	///\B
//	public static var notWordEdge: Regex { Regex("\\B") }
//	///\G
//	public static var previous: Regex { Regex("\\G") }
//	///^
//	public static var textBegin: Regex { Regex("^") }
//	///$
//	public static var textEnd: Regex { Regex("$") }
//	///`+`
//	public static var repeats: Regex { .count(.default) }
//	///`*`
//	public static var anyCount: Regex { .anyCount(.default) }
//	///`?`
//	public static var oneOrNone: Regex { .oneOrNone(.default) }
//	///`?`
//	public static func oneOrNone(_ quantification: Quantification) -> Regex { Regex("?" + quantification.rawValue) }
//	///`+`
//	public static func count(_ quantification: Quantification) -> Regex { Regex("+" + quantification.rawValue) }
//	///`*`
//	public static func anyCount(_ quantification: Quantification) -> Regex { Regex("*" + quantification.rawValue) }
//
//	///{count}
//	public static func count(_ count: Int, _ quantification: Quantification = .default) -> Regex {
//		Regex("{\(count)}" + quantification.rawValue)
//	}
//
//	///{min,max}
//	public static func count(_ range: ClosedRange<Int>, _ quantification: Quantification = .default) -> Regex {
//		Regex("{\(range.lowerBound),\(range.upperBound)}" + quantification.rawValue)
//	}
//
//	///{min,}
//	public static func count(_ range: PartialRangeFrom<Int>, _ quantification: Quantification = .default) -> Regex {
//		Regex("{\(range.lowerBound),}" + quantification.rawValue)
//	}
//
//	///{,max}
//	public static func count(_ range: PartialRangeThrough<Int>, _ quantification: Quantification = .default) -> Regex {
//		Regex("{,\(range.upperBound)}" + quantification.rawValue)
//	}
//
//	///\number
//	public static func found(_ number: Int) -> Regex {
//		Regex("\\\(number)")
//	}
//
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	public static func look(_ look: Look, _ regex: Regex) -> Regex {
//		Regex("(\(look.rawValue)\(regex))")
//	}
//
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	public static func look(_ look: Look, @RegexBuilder _ builder: () -> Regex) -> Regex {
//		.look(look, builder())
//	}
//
//	///string shielding
//	public static func string(_ string: String) -> Regex {
//		Regex((string.count > 3 ? "\\Q\(string)\\E" : string.regexShielding))
//	}
//
//	///[symbols]
//	public static func symbols(_ symbols: [Regex.SymbolsSet]) -> Regex { Regex("[\(symbols.map({ $0.value }).joined())]") }
//	///[symbols]
//	public static func symbols(@RegexSymbolsBuilder _ builder: () -> [Regex.SymbolsSet]) -> Regex { .symbols(builder()) }
//
//	///(regex)
//	public static func group(_ regex: Regex) -> Regex { .group(.simple, regex) }
//	///(regex), (?>regex), (?:regex)
//	public static func group(_ group: Group, _ regex: Regex) -> Regex { Regex("(\(group.value)\(regex.value))") }
//	///(regex), (?>regex), (?:regex)
//	public static func group(_ group: Group = .simple, @RegexBuilder _ builder: () -> Regex) -> Regex { .group(group, builder()) }
//
//	public static func modifier(_ modifier: Modifier) -> Regex { Regex("(?\(modifier.value))")
//	}
//
//	///(?(?=condition)then|else)
//	public static func `if`(look: Look, _ condition: Regex, then: Regex, else: Regex) -> Regex {
//		Regex("(?\(Regex.look(look, condition))\(then.value)|\(`else`.value))")
//	}
//
//	///(?(?=condition)then|else)
//	public static func `if`(look: Look, @RegexBuilder _ condition: () -> Regex, @RegexBuilder then: () -> Regex, @RegexBuilder  else: () -> Regex) -> Regex {
//		.if(look: look, condition(), then: then(), else: `else`())
//	}
//
//	///(?(group)then|else)
//	public static func `if`(group: Int, then: Regex, else: Regex) -> Regex {
//		Regex("(?\(group)\(then.value)|\(`else`.value))")
//	}
//
//	///(?(group)then|else)
//	public static func `if`(group: Int, @RegexBuilder then: () -> Regex, @RegexBuilder  else: () -> Regex) -> Regex {
//		.if(group: group, then: then(), else: `else`())
//	}
//
//	///regex0|regex1
//	public static func or(_ regexes: [Regex]) -> Regex {
//		Regex(regexes.map { $0.value }.joined(separator: "|"))
//	}
//
//	///regex0|regex1
//	public static func or(_ regexes: Regex...) -> Regex {
//		.or(regexes)
//	}
//
//	///regex0|regex1
//	public static func or(@RegexesBuilder _ regexes: () -> [Regex]) -> Regex {
//		.or(regexes())
//	}
//}
//
//extension Regex {
//
//	///[symbols]
//	public subscript(_ symbols: SymbolsSet...) -> Regex {
//		self + Regex(symbols)
//	}
//
//	public subscript(dynamicMember string: String) -> Regex {
//		Regex(value + string)
//	}
//
//	///`.`
//	public var any: Regex { self + .any }
//	///\d
//	public var digit: Regex { self + .digit }
//	///\D
//	public var notDigit: Regex { self + .notDigit }
//	///\s
//	public var space: Regex { self + .space }
//	///\S
//	public var notSpace: Regex { self + .notSpace }
//	///\w
//	public var wordChar: Regex { self + .wordChar }
//	///\W
//	public var notWordChar: Regex { self + .notWordChar }
//	///\n
//	public var nextLine: Regex { self + .nextLine }
//	///\r
//	public var carriageReturn: Regex { self + .carriageReturn }
//	///\b
//	public var wordEdge: Regex { self + .wordEdge }
//	///\B
//	public var notWordEdge: Regex { self + .notWordEdge }
//	///\G
//	public var previous: Regex { self + .previous }
//	///^
//	public var textBegin: Regex { self + .textBegin }
//	///$
//	public var textEnd: Regex { self + .textEnd }
//	///`+`
//	public var repeats: Regex { self + .repeats }
//	///`*`
//	public var anyCount: Regex { self + .anyCount }
//
//	///`+`
//	public func count(_ quantification: Quantification) -> Regex { self + .count(quantification) }
//	///`*`
//	public func anyCount(_ quantification: Quantification) -> Regex { self + .anyCount(quantification) }
//
//	///{count}
//	public func count(_ count: Int, _ quantification: Quantification = .default) -> Regex {
//		self + .count(count, quantification)
//	}
//
//	///{min,max}
//	public func count(_ range: ClosedRange<Int>, _ quantification: Quantification = .default) -> Regex {
//		self + .count(range, quantification)
//	}
//
//	///{min,}
//	public func count(_ range: PartialRangeFrom<Int>, _ quantification: Quantification = .default) -> Regex {
//		self + .count(range, quantification)
//	}
//
//	///{,max}
//	public func count(_ range: PartialRangeThrough<Int>, _ quantification: Quantification = .default) -> Regex {
//		self + .count(range, quantification)
//	}
//
//	///\number
//	public func found(_ number: Int) -> Regex {
//		self + .found(number)
//	}
//
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	public func look(_ look: Look, _ regex: Regex) -> Regex {
//		self + .look(look, regex)
//	}
//
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	public func look(_ look: Look, @RegexBuilder _ builder: () -> Regex) -> Regex {
//		self.look(look, builder())
//	}
//
//	///string shielding
//	public func string(_ string: String) -> Regex {
//		self + .string(string)
//	}
//
//	///[symbols]
//	public func symbols(_ symbols: [Regex.SymbolsSet]) -> Regex { self + .symbols(symbols) }
//	///[symbols]
//	public func symbols(@RegexSymbolsBuilder _ builder: () -> [Regex.SymbolsSet]) -> Regex { symbols(builder()) }
//
//	///(regex)
//	public func group(_ regex: Regex) -> Regex { self + .group(.simple, regex) }
//
//	///(regex), (?>regex), (?:regex)
//	public func group(_ group: Group, _ regex: Regex) -> Regex { self + .group(group, regex) }
//
//	///(regex), (?>regex), (?:regex)
//	public func group(_ group: Group = .simple, @RegexBuilder _ builder: () -> Regex) -> Regex { self.group(group, builder()) }
//
//	public func modifier(_ modifier: Modifier) -> Regex { self + .modifier(modifier) }
//
//	///(?(?=condition)then|else)
//	public func `if`(look: Look, _ condition: Regex, then: Regex, else: Regex) -> Regex {
//		self + .if(look: look, condition, then: then, else: `else`)
//	}
//
//	///(?(?=condition)then|else)
//	public func `if`(look: Look, @RegexBuilder _ condition: () -> Regex, @RegexBuilder then: () -> Regex, @RegexBuilder  else: () -> Regex) -> Regex {
//		self + .if(look: look, condition(), then: then(), else: `else`())
//	}
//
//	///(?(group)then|else)
//	public func `if`(group: Int, then: Regex, else: Regex) -> Regex {
//		self + .if(group: group, then: then, else: `else`)
//	}
//
//	///(?(group)then|else)
//	public func `if`(group: Int, @RegexBuilder then: () -> Regex, @RegexBuilder  else: () -> Regex) -> Regex {
//		self + .if(group: group, then: then(), else: `else`())
//	}
//
//	///regex0|regex1
//	public func or(_ regex: Regex) -> Regex {
//		.or(self, regex)
//	}
//
//	public func callAsFunction(_ input: String) -> Regex {
//		string(input)
//	}
//
//	public func callAsFunction(_ input: Regex) -> Regex {
//		callAsFunction(.simple, input)
//	}
//
//	public func callAsFunction(_ group: Group, _ input: Regex) -> Regex {
//		if input.value.hasPrefix("(") && input.value.hasSuffix(")") {
//			return self + .group(group, Regex(input.value.dropLast().dropFirst()))
//		} else {
//			return self + .group(group, input)
//		}
//	}
//
//	public func callAsFunction(_ input: () -> Int) -> Regex {
//		count(input())
//	}
//
//	public func callAsFunction(_ input: () -> ClosedRange<Int>) -> Regex {
//		count(input())
//	}
//
//	public func callAsFunction(_ input: () -> PartialRangeFrom<Int>) -> Regex {
//		count(input())
//	}
//
//	public func callAsFunction(_ input: () -> PartialRangeThrough<Int>) -> Regex {
//		count(input())
//	}
//}
//
//extension Regex {
//	///\d - digit
//	public var d: Regex { digit }
//	///\D - notDigit
//	public var D: Regex { notDigit }
//	///\s - space
//	public var s: Regex { space }
//	///\S - notSpace
//	public var S: Regex { notSpace }
//	///\w - wordChar
//	public var w: Regex { wordChar }
//	///\W - notWordChar
//	public var W: Regex { notWordChar }
//	///\n - nextLine
//	public var n: Regex { nextLine }
//	///\r - carriageReturn
//	public var r: Regex { carriageReturn }
//	///\b - wordEdge
//	public var b: Regex { wordEdge }
//	///\B - notWordEdge
//	public var B: Regex { notWordEdge }
//	///\G - previous
//	public var G: Regex { previous }
//
//	///\d - digit
//	public static var d: Regex { digit }
//	///\D - notDigit
//	public static var D: Regex { notDigit }
//	///\s - space
//	public static var s: Regex { space }
//	///\S - notSpace
//	public static var S: Regex { notSpace }
//	///\w - wordChar
//	public static var w: Regex { wordChar }
//	///\W - notWordChar
//	public static var W: Regex { notWordChar }
//	///\n - nextLine
//	public static var n: Regex { nextLine }
//	///\r - carriageReturn
//	public static var r: Regex { carriageReturn }
//	///\b - wordEdge
//	public static var b: Regex { wordEdge }
//	///\B - notWordEdge
//	public static var B: Regex { notWordEdge }
//	///\G - previous
//	public static var G: Regex { previous }
//}
//
//extension Regex {
//
//	///[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}
//	public static var email: Regex { Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") }
//}
