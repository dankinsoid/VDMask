////
////  File.swift
////
////
////  Created by Данил Войдилов on 04.11.2021.
////
//
//import Foundation
//
//indirect enum _Regex: RawRepresentable {
//	case sequence([_Regex])
//	///()
//	case group(Regex.Group, _Regex)
//	///[]
//	case symbolsSet([Regex.SymbolsSet])
//	///`.`
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
//	case oneOrNone(quantification: Regex.Quantification = .default) //-> Regex { Regex("?" + quantification.rawValue) }
//	///`+`
//	case oneAndMore(quantification: Regex.Quantification = .default) //-> Regex { Regex("+" + quantification.rawValue) }
//	///`*`
//	case anyCount(quantification: Regex.Quantification = .default) //-> Regex { Regex("*" + quantification.rawValue) }	///{count}
//	///{n}
//	case count(_ count: Int, _ quantification: Regex.Quantification = .default) //		Regex("{\(count)}" + quantification.rawValue
//	///{min,max}
//	case countRange(_ range: ClosedRange<Int>, _ quantification: Regex.Quantification = .default)// -> Regex { Regex("{\(range.lowerBound),\(range.upperBound)}" + quantification.rawValue)
//	///{min,}
//	case countFrom(_ range: Int, _ quantification: Regex.Quantification = .default) //-> Regex { Regex("{\(range.lowerBound),}" + quantification.rawValue)}
//	///{,max}
//	case countTo(_ range: Int, _ quantification: Regex.Quantification = .default) //-> Regex { Regex("{,\(range.upperBound)}" + quantification.rawValue) }
//
////	case count(_ range: ClosedRange<Int>, _ quantification: Regex.Quantification = .default)// -> Regex { Regex("{\(range.lowerBound),\(range.upperBound)}" + quantification.rawValue)
////	///{min,}
////	case count(_ range: PartialRangeFrom<Int>, _ quantification: Regex.Quantification = .default) //-> Regex { Regex("{\(range.lowerBound),}" + quantification.rawValue)}
////	///{,max}
////	case count(_ range: PartialRangeThrough<Int>, _ quantification: Regex.Quantification = .default) //-> Regex { Regex("{,\(range.upperBound)}" + quantification.rawValue) }
//	///\number
//	case found(_ number: Int) //-> Regex { Regex("\\\(number)") }
//	///(?<=regex), (?=regex), (?<!regex), (?!regex)
//	case look(_ look: Regex.Look, _ regex: _Regex)// -> Regex { Regex("(\(look.rawValue)\(regex))") }
//	///\Qstring\E
//	case shielded(_ string: String) //Regex((string.count > 3 ? "\\Q\(string)\\E" : string.regexShielding))
//	///(?modifier)
//	case modifier(_ modifier: Regex.Modifier)// -> Regex { Regex("(?\(modifier.value))")
//	///(?(?=condition)then|else)
//	case `if`(look: Regex.Look, _ condition: _Regex, then: _Regex, else: _Regex)// -> Regex { Regex("(?\(Regex.look(look, condition))\(then.value)|\(`else`.value))") }
//	///(?(group)then|else)
//	case `if`(group: Int, then: _Regex, else: _Regex)//-> Regex {Regex("(?\(group)\(then.value)|\(`else`.value))")
//	///regex0|regex1
//	case or(_ regexes: [_Regex]) //-> Regex {		Regex(regexes.map { $0.value }.joined(separator: "|")) }
//
//	var rawValue: String {
//		switch self {
//		case .sequence(let regexes): return regexes.map { $0.rawValue }.joined()
//		case .group(let group, let regex): return "(\(group.value)\(regex.rawValue))"
//		case .symbolsSet(let array): return "[\(array.map { $0.value }.joined())]"
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
//		case .oneOrNone(let quantification):
//		case .oneAndMore(let quantification):
//		case .anyCount(let quantification):
//		case .count(let _, let quantification):
//		case .countRange(let _, let quantification):
//		case .countFrom(let _, let quantification):
//		case .countTo(let _, let quantification):
//		case .found(let _):
//		case .look(let _, let _):
//		case .shielded(let _):
//		case .modifier(let modifier):
//		case .if(let look, let _, let then, let else, let regex):
//		case .if(let group, let then, let else, let regex):
//		case .or(let regexes):
//		}
//	}
//
//	init?(rawValue: String) {
//		return nil
//	}
//
////	func scan(string: String, index: inout String.Index) -> Bool {
////		switch self {
////		case .group(let group, let _regex):
////			return false
////		case .symbolsSet(let array):
////			return false
////		}
////	}
//}
