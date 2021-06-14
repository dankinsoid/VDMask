//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

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
	
	public static func +(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex(lhs.value + rhs.value)
	}
	
	public static func |(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex("\(lhs.value)|\(rhs.value)")
	}
}
