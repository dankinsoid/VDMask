//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.12.2021.
//

import Foundation

extension Regex {
	
	public struct StringInterpolation: StringInterpolationProtocol {
		public typealias StringLiteralType = String
		public var regex: Regex
		
		public init(literalCapacity: Int, interpolationCount: Int) {
			self.regex = Regex(elements: [])
		}
		
		public mutating func appendLiteral(_ literal: String) {
			regex += .string(literal)
		}
		
		public mutating func appendInterpolation(_ set: SymbolsSet) {
			regex += .set(set)
		}
	}
}
