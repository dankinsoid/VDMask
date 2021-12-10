//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.11.2021.
//

import Foundation

extension Regex {
	
	func scan(string: String, context: inout RegexScanContext) throws {
		switch self {
		case .sequence(let array):
			try array.forEach {
				try $0.scan(string: string, context: &context)
			}
			
		case .string(let str), .shielded(let str):
			var index = context.index
			var i = str.startIndex
			while i < str.endIndex, index < string.endIndex, compare(string[index], str[i], context: context) {
				i = str.index(after: i)
				index = string.index(after: index)
			}
			if i < str.endIndex, index < string.endIndex {
				throw RegexScanError.notMatch(index)
			} else if i < str.endIndex {
				throw RegexScanError.stringTooShort
			}
			context.index = index
			
		case .group(let group, let regex):
			let start = context.index
			let modifiers = context.modifiers
			context.deep += 1
			if case .modifier(let modifiers) = group {
				context.modifiers.formUnion(modifiers)
			}
			do {
				try regex.scan(string: string, context: &context)
				context.deep -= 1
				context.modifiers = modifiers
				if start <= context.index, group != .nonCapturing, group != .atomic {
					context.foundGroups[context.deep, default: []].append(start..<context.index)
				}
#warning("TODO")
			} catch {
				context.deep -= 1
				context.modifiers = modifiers
				context.index = start
				throw error
			}
			
		case .symbolsSet(let array):
			#warning("TODO")
			break
			
		case .any:
			try scanChar(string: string, context: &context) {
				context.modifiers.contains(.s) ? $0 != "\n" && $0 != "\r" : true
			}
			
		case .digit:
			try scanChar(string: string, context: &context, condition: CharacterSet.decimalDigits.contains)
			
		case .notDigit:
			try scanChar(string: string, context: &context) {
				!CharacterSet.decimalDigits.contains($0)
			}
			
		case .space:
			try scanChar(string: string, context: &context, condition: CharacterSet.whitespacesAndNewlines.contains)
			
		case .notSpace:
			try scanChar(string: string, context: &context) {
				!CharacterSet.whitespacesAndNewlines.contains($0)
			}
			
		case .wordChar:
			try scanChar(string: string, context: &context, condition: CharacterSet.word.contains)
			
		case .notWordChar:
			try scanChar(string: string, context: &context) {
				!CharacterSet.word.contains($0)
			}
			
		case .nextLine:
			try scanChar(string: string, context: &context) {
				$0 == "\n"
			}
			
		case .carriageReturn:
			try scanChar(string: string, context: &context) {
				$0 == "\r"
			}
			
		case .wordEdge:
			guard isWordEdge(string: string, context: &context) else {
				throw RegexScanError.notMatch(context.index)
			}
			
		case .notWordEdge:
			guard !isWordEdge(string: string, context: &context) else {
				throw RegexScanError.notMatch(context.index)
			}
			
		case .previous:
#warning("TODO")
			break
		
		case .textBegin:
			if context.modifiers.contains(.m) {
				if context.index > string.startIndex, string[string.index(before: context.index)] != "\n" {
					throw RegexScanError.notMatch(context.index)
				}
			} else {
				if context.index > string.startIndex {
					throw RegexScanError.notMatch(context.index)
				}
			}
			
		case .textEnd:
			if context.modifiers.contains(.m) {
				if context.index < string.index(before: string.endIndex), string[string.index(after: context.index)] != "\n" {
					throw RegexScanError.notMatch(context.index)
				}
			} else {
				if context.index < string.index(before: string.endIndex) {
					throw RegexScanError.notMatch(context.index)
				}
			}
			
		case .oneOrNone(let regex, let quantification):
			try Regex.repeat(0...1, regex, quantification: quantification).scan(string: string, context: &context)
			
		case .oneAndMore(let regex, let quantification):
			try Regex.repeat(1..., regex, quantification: quantification).scan(string: string, context: &context)
			
		case .anyCount(let regex, let quantification):
			try Regex.repeat(0..., regex, quantification: quantification).scan(string: string, context: &context)
			
		case .repeat(let count, let regex, let quantification):
			guard count > 0 else { break }
			for _ in 0..<count {
				try regex.scan(string: string, context: &context)
			}
			
		case .repeatIn(let range, let regex, let quantification):
			let start = context.index
			for i in range {
				try Regex.repeat(i, regex, quantification).scan(string: string, context: &context)
			}
			
		case .repeatFrom(let min, let regex, let quantification):
			
			 
		case .repeatTo(let max, let regex, let quantification):
			guard max >= 0 else { break }
			try Regex.repeatIn(0...max, regex, quantification).scan(string: string, context: &context)
			
		case .found(let i):
			let found = context.foundGroups[context.deep] ?? []
			if i > 0, i <= found.count {
				try Regex.string(String(string[found[i - 1]])).scan(string: string, context: &context)
			} else {
				throw RegexScanError.tooLargeIndex(i)
			}
			
		case .look(let _, let _):
			
			
		case .modifier(let modifiers):
			context.modifiers.formUnion(modifiers)
			
		case .ifLook(let _, let _, let then, let `else`):
			
			
		case .if(let group, let then, let `else`, let regex):
			
		case .or(let regexes):
			let i = context.index
			var _error: Error?
			for regex in regexes {
				do {
					try regex.scan(string: string, context: &context)
					break
				} catch {
					context.index = i
					_error = error
				}
			}
			if let error = _error {
				throw error
			}
		}
	}
	
	private func compare(_ char1: Character, _ char2: Character, context: RegexScanContext) -> Bool {
		if context.modifiers.contains(.i) {
			return char1.lowercased() == char2.lowercased()
		} else {
			return char1 == char2
		}
	}
	
	private func scanChar(string: String, context: inout RegexScanContext, condition: (Character) -> Bool) throws {
		guard context.index < string.endIndex else { throw RegexScanError.stringTooShort }
		if condition(string[context.index]) {
			context.index = string.index(after: context.index)
		} else {
			throw RegexScanError.notMatch(context.index)
		}
	}
	
	private func isWordEdge(string: String, context: inout RegexScanContext) -> Bool {
		guard context.index < string.endIndex else {
			if string.last.map(CharacterSet.word.contains) != true {
				return false
			}
			return true
		}
		guard context.index > string.startIndex else {
			if string.first.map(CharacterSet.word.contains) != true {
				return false
			}
			return true
		}
		if CharacterSet.word.contains(string[context.index]) {
			guard !CharacterSet.word.contains(string[string.index(before: context.index)]) else {
				return false
			}
		}
		let nextIndex = string.index(after: context.index)
		guard nextIndex == string.endIndex || CharacterSet.word.contains(string[nextIndex]) || CharacterSet.word.contains(string[string.index(before: context.index)]) else {
			return false
		}
		return true
	}
}

struct RegexScanContext {
	var index: String.Index
	var deep = 0
	var modifiers: Regex.Modifiers = []
	var foundGroups: [Int: [Range<String.Index>]] = [:]
	
	init(startFrom: String.Index) {
		index = startFrom
	}
}

enum RegexScanError: Error {
	case notMatch(String.Index)
	case stringTooShort
	case tooLargeIndex(Int)
}
