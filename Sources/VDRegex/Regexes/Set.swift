//
//  File.swift
//  
//
//  Created by Данил Войдилов on 12.12.2021.
//

import Foundation

extension Regex.SymbolsSet: RegexType {
	
	public init(pattern: String, index: inout String.Index) throws {
		var context = SymbolsSetParser.Context(index: index)
		try SymbolsSetParser().parse(string: string, context: &context)
		index = context.index
		self = context.set
	}
	
	public func scan(string: String, context: inout RegexScanContext) throws {
		try scanChar(string: string, context: &context) {
			contains($0)
		}
	}
}

extension Regex {
	public static func set(_ set: Regex.SymbolsSet) -> Regex {
		Regex(regex: set)
	}
}
