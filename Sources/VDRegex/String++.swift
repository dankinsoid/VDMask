//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

public func ~=<T: StringProtocol>(lhs: Regex, rhs: T) -> Bool {
	rhs.match(lhs)
}

extension StringProtocol {
	
	private var nsRange: NSRange { NSRange(startIndex..., in: self) }
	
	public func match(_ regex: Regex) -> Bool {
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex.value)
		return emailPredicate.evaluate(with: String(self))
	}
	
	public func match(@RegexBuilder _ regex: () -> Regex) -> Bool {
		match(regex())
	}
	
	public func replacing<T: StringProtocol>(_ regex: Regex, with template: T) -> String {
		regex.ns?.stringByReplacingMatches(in: String(self), options: [], range: nsRange, withTemplate: String(template)) ?? String(self)
	}
	
	public func matches<T: StringProtocol>(_ regex: Regex, with template: T) -> [String] {
		regex.ns?.matches(in: String(self), options: [], range: nsRange).map {
			substring(with: $0.range)
		} ?? []
	}
	
	public func firstMatch<T: StringProtocol>(_ regex: Regex, with template: T) -> String? {
		regex.ns?.firstMatch(in: String(self), options: [], range: nsRange).map {
			substring(with: $0.range)
		}
	}
	
	public func numberOfMatches<T: StringProtocol>(_ regex: Regex, with template: T) -> Int {
		regex.ns?.numberOfMatches(in: String(self), options: [], range: nsRange) ?? 0
	}
	
	private func substring(with range: NSRange) -> String {
		if #available(iOS 13, *) {
			return Range(range, in: self).map { String(self[$0]) } ?? ""
		} else {
			return (String(self) as NSString).substring(with: range)
		}
	}
}


extension String {
	var regexShielding: String {
		map { CharacterSet.regexSpecial.contains($0) ? "\\\($0)" : String($0) }.joined()
			.replacingOccurrences(of: "\n", with: "\\n")
	}
}

extension CharacterSet {
	
	public static var regexSpecial: CharacterSet {
		CharacterSet(charactersIn: "[]\\/^$.|?*+(){}")
	}
	
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy(contains)
	}
}
