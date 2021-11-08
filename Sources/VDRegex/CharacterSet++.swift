//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.11.2021.
//

import Foundation

extension CharacterSet {
	/// regex special characters []\/^$.|?*+(){}
	public static var regexSpecial: CharacterSet {
		["[", "]", "\\", "/", "^", "$", ".", "|", "?", "*", "+", "(", ")", "{", "}"]
	}
	
	static var word: CharacterSet { CharacterSet.alphanumerics.union(["_"]) }
	
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy(contains)
	}
	
	public init(_ ranges: ClosedRange<Unicode.Scalar>...) {
		self = ranges.reduce(CharacterSet()) { $0.union(CharacterSet(charactersIn: $1)) }
	}
}
