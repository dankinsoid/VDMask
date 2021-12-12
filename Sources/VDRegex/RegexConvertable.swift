//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.11.2021.
//

import Foundation

public protocol RegexConvertable {
	var asRegex: Regex { get }
}

extension RegexConvertable {
	public var ns: NSRegularExpression? {
		try? NSRegularExpression(pattern: asRegex.pattern)
	}
	
	public var countOfGroups: Int {
		ns?.numberOfCaptureGroups ?? 0
	}
}

//extension NSRegularExpression: RegexConvertable {
//	public var asRegex: Regex { Regex(pattern) }
//}

public protocol RegexValueType {
	static var regex: Regex { get }
}

public protocol StringInitable {
	init?(string: String)
}

extension RegexValueType where Self: StringProtocol {
	public static var regex: Regex { Regex(".*") }
}

extension RegexValueType where Self: UnsignedInteger {
	public static var regex: Regex { Regex("[0-9]*") }
}

extension RegexValueType where Self: SignedInteger {
	public static var regex: Regex { Regex("[-+]?[0-9]*") }
}

extension RegexValueType where Self: FloatingPoint {
	public static var regex: Regex { Regex("[+-]?([0-9]*[.])?[0-9]+") }
}

extension String: RegexValueType, StringInitable {
	public init?(string: String) {
		self = string
	}
}

extension Int: RegexValueType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension UInt: RegexValueType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension Double: RegexValueType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension Float: RegexValueType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}
