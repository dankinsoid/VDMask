//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

prefix operator ^
prefix operator ?=
prefix operator ?!
prefix operator ?<=
prefix operator ?<!

postfix operator +
postfix operator *
postfix operator *?
postfix operator +?
postfix operator *+
postfix operator ++
prefix operator ?>

//public postfix func +(_ lhs: Regex) -> Regex {
//	lhs.repeats
//}
//
//public postfix func *(_ lhs: Regex) -> Regex {
//	lhs.anyCount
//}
//
//public postfix func *?(_ lhs: Regex) -> Regex {
//	Regex(lhs.value + "*?")
//}
//
//public postfix func +?(_ lhs: Regex) -> Regex {
//	Regex(lhs.value + "+?")
//}
//
//public postfix func *+(_ lhs: Regex) -> Regex {
//	Regex(lhs.value + "*+")
//}
//
//public postfix func ++(_ lhs: Regex) -> Regex {
//	Regex(lhs.pattern + "++")
//}
//
//public prefix func ^(_ rhs: Regex) -> Regex {
//	Regex("^" + rhs.pattern)
//}
//
//public prefix func !(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
//	^rhs
//}
//
//public prefix func ?>(_ rhs: Regex) -> Regex {
//	Regex("(?>\(rhs.pattern))")
//}
//
//public prefix func ?=(_ rhs: Regex) -> Regex {
//	Regex("(?=\(rhs.pattern))")
//}
//
//public prefix func ?!(_ rhs: Regex) -> Regex {
//	Regex("(?!\(rhs.pattern))")
//}
//
//public prefix func ?<=(_ rhs: Regex) -> Regex {
//	Regex("(?<=\(rhs.pattern))")
//}
//
//public prefix func ?<!(_ rhs: Regex) -> Regex {
//	Regex("(?<!\(rhs.pattern))")
//}

extension Regex {
	
//	var asArray: [Regex] {
//		if case .sequence(let array) = self { return array }
//		return [self]
//	}
//
	public static func +(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex(elements: lhs.elements + rhs.elements)
	}
//
//	public static func |(_ lhs: Regex, _ rhs: Regex) -> Regex {
//		.or(lhs, rhs)
//	}
}

public func +=(_ lhs: inout Regex, _ rhs: Regex) {
	lhs.elements.append(contentsOf: rhs.elements)
}
