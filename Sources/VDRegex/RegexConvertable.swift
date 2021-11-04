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
		try? NSRegularExpression(pattern: asRegex.value)
	}
	
	public var countOfGroups: Int {
		ns?.numberOfCaptureGroups ?? 0
	}
}

extension NSRegularExpression: RegexConvertable {
	public var asRegex: Regex { Regex(pattern) }
}

public protocol RegexType {
	static var regex: Regex { get }
}

public protocol StringInitable {
	init?(string: String)
}

extension RegexType where Self: StringProtocol {
	public static var regex: Regex { Regex(".*") }
}

extension RegexType where Self: UnsignedInteger {
	public static var regex: Regex { Regex("[0-9]*") }
}

extension RegexType where Self: SignedInteger {
	public static var regex: Regex { Regex("[-+]?[0-9]*") }
}

extension RegexType where Self: FloatingPoint {
	public static var regex: Regex { Regex("[+-]?([0-9]*[.])?[0-9]+") }
}

extension String: RegexType, StringInitable {
	public init?(string: String) {
		self = string
	}
}

extension Int: RegexType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension UInt: RegexType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension Double: RegexType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}

extension Float: RegexType, StringInitable {
	public init?(string: String) {
		self.init(string)
	}
}
