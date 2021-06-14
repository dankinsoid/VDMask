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
	
	public func match(_ regex: Regex) -> Bool {
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex.value)
		return emailPredicate.evaluate(with: String(self))
	}
	
	public func replacing(_ regex: Regex, with template: String) -> String {
		regex.ns?.stringByReplacingMatches(in: String(self), options: [], range: NSRange(location: 0, length: count), withTemplate: template) ?? String(self)
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
