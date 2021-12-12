//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	public enum Group: Equatable {
		case simple
		///?>
		case atomic
		///?:
		case nonCapturing
		///?modifier:
		case modifier(Modifiers)
		
		public var value: String {
			switch self {
			case .atomic: 								return "?>"
			case .nonCapturing: 					return "?:"
			case .simple: 								return ""
			case .modifier(let modifier):	return "?\(modifier.pattern):"
			}
		}
	}
}

extension Regex {
	
	public struct Modifiers: OptionSet, Codable {
		///case insensitive
		public static var i: Modifiers { Modifiers(rawValue: 0b0000000000000000_0000000000000001) }
		public static var m: Modifiers { Modifiers(rawValue: 0b0000000000000000_0000000000000010) }
		public static var s: Modifiers { Modifiers(rawValue: 0b0000000000000000_0000000000000100) }
		public static var x: Modifiers { Modifiers(rawValue: 0b0000000000000000_0000000000001000) }
		
		///case insensitive
		public var i: Modifiers { union(.i) }
		public var m: Modifiers { union(.m) }
		public var s: Modifiers { union(.s) }
		public var x: Modifiers { union(.x) }
		
		public var rawValue: UInt32
		
		public init(rawValue: UInt32) {
			self.rawValue = rawValue
 		}
		
		public init(pattern: String) {
			let array = pattern.components(separatedBy: "-")
			let dict: [Character: UInt32] = ["i": 1, "m": 2, "s": 4, "x": 8]
			var raw = array[0].reduce(0) { $0 | dict[$1, default: 0] }
			if array.count > 1 {
				raw |= array[1].reduce(0) { $0 | dict[$1, default: 0] } << 16
			}
			self = Modifiers(rawValue: raw)
		}
		
		public init(from decoder: Decoder) throws {
			self = try Modifiers(pattern: String(from: decoder))
		}
		
		public var pattern: String {
			var result = ""
			if contains(.i) { result += "i" }
			if contains(.m) { result += "m" }
			if contains(.s) { result += "s" }
			if contains(.x) { result += "x" }
			
			if rawValue >> 16 != 0 {
				result += "-"
			}
			if contains(-.i) { result += "i" }
			if contains(-.m) { result += "m" }
			if contains(-.s) { result += "s" }
			if contains(-.x) { result += "x" }
			return result
		}
		
		public __consuming func union(_ other: __owned Modifiers) -> Modifiers {
			Modifiers(rawValue:
									((((rawValue >> 16) & ~other.rawValue) | (other.rawValue >> 16)) << 16) |
									((((rawValue & ~(other.rawValue >> 16)) | other.rawValue) << 16) >> 16)
			)
		}
		
		public __consuming func intersection(_ other: Modifiers) -> Modifiers {
			Modifiers(rawValue: rawValue & other.rawValue)
		}
		
		public __consuming func symmetricDifference(_ other: __owned Modifiers) -> Modifiers {
			Modifiers(rawValue:
									((((rawValue >> 16) & ~other.rawValue) ^ (other.rawValue >> 16)) << 16) |
									((((rawValue & ~(other.rawValue >> 16)) ^ other.rawValue) << 16) >> 16)
			)
		}
		
		@discardableResult
		public mutating func insert(_ newMember: __owned Modifiers) -> (inserted: Bool, memberAfterInsert: Modifiers) {
			let prev = rawValue
			formUnion(newMember)
			return (prev != rawValue, self)
		}
		
		@discardableResult
		public mutating func remove(_ member: Modifiers) -> Modifiers? {
			let deleted = member.rawValue & rawValue
			rawValue = rawValue & ~member.rawValue
			return deleted == 0 ? nil : Modifiers(rawValue: deleted)
		}
		
		@discardableResult
		public mutating func update(with newMember: __owned Modifiers) -> Modifiers? {
			let prev = rawValue
			insert(newMember)
			return prev != rawValue ? self : nil
		}
		
		public mutating func formUnion(_ other: __owned Modifiers) {
			self = union(other)
		}
		
		public mutating func formIntersection(_ other: Modifiers) {
			self = intersection(other)
		}
		
		public mutating func formSymmetricDifference(_ other: __owned Modifiers) {
			self = symmetricDifference(other)
		}
		
		public func encode(to encoder: Encoder) throws {
			try pattern.encode(to: encoder)
		}
	}
}

public prefix func -(_ rhs: Regex.Modifiers) -> Regex.Modifiers {
	Regex.Modifiers(rawValue: (rhs.rawValue << 16) | (rhs.rawValue >> 16))
}
