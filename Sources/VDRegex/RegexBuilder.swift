//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

@resultBuilder
public enum RegexBuilder {
	
	@inlinable
	public static func buildBlock(_ components: Regex...) -> Regex {
		create(from: components)
	}
	
	@inlinable
	public static func buildArray(_ components: [Regex]) -> Regex {
		create(from: components)
	}
	
	@inlinable
	public static func buildEither(first component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildEither(second component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildOptional(_ component: Regex?) -> Regex {
		component ?? create(from: [])
	}
	
	@inlinable
	public static func buildLimitedAvailability(_ component: Regex) -> Regex {
		component
	}
	
	@inlinable
	public static func buildExpression(_ expression: Regex) -> Regex {
		expression
	}
	
	@inlinable
	public static func buildExpression(_ expression: [Regex.SymbolsSet]) -> Regex {
		Regex(expression)
	}
	
	@inlinable
	public static func buildExpression(_ string: String) -> Regex {
		.string(string)
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> Int) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> ClosedRange<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> PartialRangeFrom<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func buildExpression(_ regexes: () -> PartialRangeThrough<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	@inlinable
	public static func create(from regexes: [Regex]) -> Regex {
		Regex(regexes.map { $0.value }.joined())
	}
}
