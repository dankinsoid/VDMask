//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	public enum Group {
		case simple
		///?>
		case atomic
		///?:
		case nonCapturing
		///?#
		case comment
		///?modifier:
		case modifier(Modifier)
		
		public var value: String {
			switch self {
			case .atomic: 								return "?>"
			case .nonCapturing: 					return "?:"
			case .simple: 								return ""
			case .comment: 								return "?#"
			case .modifier(let modifier):	return "?\(modifier.value):"
			}
		}
	}
}

extension Regex {
	
	public struct Modifier: ExpressibleByArrayLiteral, ExpressibleByStringInterpolation {
		public var value: String
		
		public init<T: StringProtocol>(_ value: T) {
			self.value = String(value)
		}
		
		public init(stringLiteral value: String) {
			self.value = value
		}
		
		public init(arrayLiteral elements: Modifier...) {
			self = .init(elements)
		}
		
		public init(_ elements: [Modifier]) {
			var positive: [String] = []
			var negative: [String] = []
			elements.forEach {
				if $0.value.hasPrefix("-") {
					negative.append(String($0.value.dropFirst()))
				} else {
					positive.append($0.value)
				}
			}
			value = positive.joined() + (negative.isEmpty ? "" : "-" + negative.joined())
		}
	}
}

extension Regex.Modifier {
	public static var i: Regex.Modifier { Regex.Modifier("i") }
	public static var m: Regex.Modifier { Regex.Modifier("m") }
	public static var s: Regex.Modifier { Regex.Modifier("s") }
	public static var x: Regex.Modifier { Regex.Modifier("x") }
	
	///i
	public static var caseInsensitive: Regex.Modifier { .i }
	
	///case insensitive
	public var i: Regex.Modifier { Regex.Modifier(value + Regex.Modifier.i.value) }
	public var m: Regex.Modifier { Regex.Modifier(value + Regex.Modifier.m.value) }
	public var s: Regex.Modifier { Regex.Modifier(value + Regex.Modifier.s.value) }
	public var x: Regex.Modifier { Regex.Modifier(value + Regex.Modifier.x.value) }
}

public prefix func !(_ rhs: Regex.Modifier) -> Regex.Modifier {
	-rhs
}

public prefix func -(_ rhs: Regex.Modifier) -> Regex.Modifier {
	Regex.Modifier("-" + rhs.value)
}
