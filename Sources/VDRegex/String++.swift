//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

//public func ~=<R: RegexConvertable, T: StringProtocol>(lhs: R, rhs: T) -> Bool {
//	rhs.match(lhs)
//}

extension StringProtocol {
	
//	private var nsRange: NSRange { NSRange(startIndex..., in: self) }
	
//	public func match<R: RegexConvertable>(_ regex: R) -> Bool {
//		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex.asRegex.value)
//		return emailPredicate.evaluate(with: String(self))
//	}
//
//	public func match(@RegexBuilder _ regex: () -> Regex) -> Bool {
//		match(regex())
//	}
	
//	public func replacing<R: RegexConvertable, T: StringProtocol>(_ regex: R, with template: T) -> String {
//		regex.ns?.stringByReplacingMatches(in: String(self), options: [], range: nsRange, withTemplate: String(template)) ?? String(self)
//	}
//
//	public func matches<R: RegexConvertable, T: StringProtocol>(_ regex: R, with template: T) -> [String] {
//		regex.ns?.matches(in: String(self), options: [], range: nsRange).map {
//			substring(with: $0.range)
//		} ?? []
//	}
//
//	public func firstMatch<R: RegexConvertable, T: StringProtocol>(_ regex: R, with template: T) -> String? {
//		regex.ns?.firstMatch(in: String(self), options: [], range: nsRange).map {
//			substring(with: $0.range)
//		}
//	}
//
//	public func numberOfMatches<R: RegexConvertable, T: StringProtocol>(_ regex: R, with template: T) -> Int {
//		regex.ns?.numberOfMatches(in: String(self), options: [], range: nsRange) ?? 0
//	}
//
//	private func substring(with range: NSRange) -> String {
//		if #available(iOS 13, *) {
//			return Range(range, in: self).map { String(self[$0]) } ?? ""
//		} else {
//			return (String(self) as NSString).substring(with: range)
//		}
//	}
	
	func dd() {
//		"int: 93"
//		str.replace("int: (Int.self)") { int in "int: \(int + 1)" }
//		str.replaceValue("int: (Int.self)") { $0 + 1 }
//		str.values("int: (Int.self)") -> [Int]
//		Regex("int: (Int.self)").with(int) -> String
//		str.formatted[regex]
//		RegexFormatter(regex)
	}
}

extension String {
	public var regexShielding: String {
		map { CharacterSet.regexSpecial.contains($0) ? "\\\($0)" : String($0) }.joined()
			.replacingOccurrences(of: "\n", with: "\\n")
	}
}
