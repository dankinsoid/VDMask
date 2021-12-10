//
//  File.swift
//  
//
//  Created by Данил Войдилов on 08.11.2021.
//

import Foundation
import UIKit

struct SymbolsSetParser {
	
	var parseConstants = true
	 
	func parse(string: String, context: inout Context) throws {
		defer {
			if let cached = context.cache {
				context.parsed.append(cached...cached)
			}
		}
		while context.index < string.endIndex {
			switch string[context.index] {
			case "^":
				if context.index == string.startIndex {
					context.isInverted = true
				} else {
					try add(char: "^", string: string, parser: &context)
				}
				context.index = string.index(after: context.index)
			case "\\":
				try add(char: parseShielded(string: string, context: &context), string: string, parser: &context)
			case "-":
				if context.cache != nil {
					guard !context.isRange else {
						throw ParserError.outOfOrder
					}
					context.isRange = true
				} else {
					try add(char: "-", string: string, parser: &context)
				}
				context.index = string.index(after: context.index)
			case "[":
				if parseConstants, let set = parseConstants(string: string, context: &context) {
					context.parsed += set.rawValue
				} else {
					try add(char: string[context.index], string: string, parser: &context)
					context.index = string.index(after: context.index)
				}
			case "]":
				context.index = string.index(after: context.index)
				return
			default:
				try add(char: string[context.index], string: string, parser: &context)
				context.index = string.index(after: context.index)
			}
		}
	}
	
	private func add(char: Character, string: String, parser: inout Context) throws {
		if parser.isRange, let lower = parser.cache {
			guard lower <= char else {
				throw ParserError.incorrectRange
			}
			parser.cache = nil
			parser.isRange = false
			parser.parsed.append(lower...char)
		} else {
			if let cached = parser.cache {
				parser.parsed.append(cached...cached)
			}
			parser.cache = char
		}
	}
	
	private func parseShielded(string: String, context: inout Context) throws -> Character {
		context.index = string.index(after: context.index)
		guard context.index < string.endIndex else {
			throw ParserError.backslashEnd
		}
		switch string[context.index] {
		case "0":
			context.index = string.index(after: context.index)
			return "\0"
		case "t":
			context.index = string.index(after: context.index)
			return "\t"
		case "n":
			context.index = string.index(after: context.index)
			return "\n"
		case "v":
			context.index = string.index(after: context.index)
			return "\u{B}"
		case "f":
			context.index = string.index(after: context.index)
			return "\u{C}"
		case "r":
			context.index = string.index(after: context.index)
			return "\r"
		case "x":
			return try parseUnicode(string: string, context: &context, count: 2)
		case "u":
			return try parseUnicode(string: string, context: &context, count: 4)
		default:
			let char = string[context.index]
			context.index = string.index(after: context.index)
			return char
		}
	}
	
	private func parseUnicode(string: String, context: inout Context, count: Int) throws -> Character {
		guard string.distance(from: context.index, to: string.endIndex) > count else {
			throw ParserError.incompleteToken
		}
		guard let value = UInt32(string[string.index(after: context.index)...string.index(context.index, offsetBy: count)], radix: 16), let scalar = Unicode.Scalar(value) else {
			throw ParserError.incompleteToken
		}
		context.index = string.index(context.index, offsetBy: count + 1)
		return Character(scalar)
	}
	
	private func parseConstants(string: String, context: inout Context) -> Regex.SymbolsSet? {
		for count in Regex.SymbolsSet.constantsLenghts {
			if string.distance(from: context.index, to: string.endIndex) >= count, let set = Regex.SymbolsSet.constants[String(string[context.index..<string.index(context.index, offsetBy: count)])] {
				context.index = string.index(context.index, offsetBy: count)
				return set
			}
		}
		return nil
	}
	
	private func upTo(char: Character, string: String, index: String.Index) -> String.Index? {
		var i = index
		while i < string.endIndex, string[i] != char {
			i = string.index(after: i)
		}
		return i < string.endIndex ? i : nil
	}
		
	struct Context {
		var index: String.Index
		var parsed: [ClosedRange<Character>] = []
		var cache: Character?
		var isRange: Bool = false
		var isInverted: Bool = false
		var set: Regex.SymbolsSet {
			isInverted ? Regex.SymbolsSet(rawValue: parsed).inverted : Regex.SymbolsSet(rawValue: parsed)
		}
	}
}

enum ParserError: String, Error {
	case backslashEnd = "Pattern may not end with a trailing backslash"
	case incompleteToken = "The token is incomplete"
	case outOfOrder = "Character range is out of order"
	case incorrectRange = "Incorrect range"
	case incorrectPattern = "Incorrect pattern"
}
