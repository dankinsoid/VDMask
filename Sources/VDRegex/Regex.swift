//
//  File.swift
//  
//
//  Created by Данил Войдилов on 31.05.2021.
//

import Foundation

@dynamicMemberLookup
public struct Regex: Equatable, Hashable, Codable, ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
	public var value: String
	public var description: String { value }
	
	public init() {
		value = ""
	}
	
	public init(_ value: String) {
		self.value = value
	}
	
	public init<T: StringProtocol>(_ value: T) {
		self.value = String(value)
	}
	
	public init(stringLiteral value: String) {
		self.value = value
	}
	
	public init(arrayLiteral elements: SymbolsSet...) {
		self.init(elements)
	}
	
	public init(from decoder: Decoder) throws {
		value = try String(from: decoder)
	}
	
	public init(@RegexBuilder _ builder: () -> Regex) {
		self = builder()
	}
	
	public func encode(to encoder: Encoder) throws {
		try value.encode(to: encoder)
	}
}

extension Regex {
	public var ns: NSRegularExpression? {
		try? NSRegularExpression(pattern: value)
	}
}
