//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	public enum Look: RawRepresentable, Codable, Hashable {
		///?
		case behind(Negation)
		///?<
		case ahead(Negation)
		
		public static var behind: Look { .behind(.equal) }
		public static var ahead: Look { .ahead(.equal) }
		
		public var rawValue: String {
			switch self {
			case .ahead(let negation): return "?" + negation.rawValue
			case .behind(let negation): return "?<" + negation.rawValue
			}
		}
		
		public init?(rawValue: String) {
			switch rawValue {
			case "?=": self = .ahead(.equal)
			case "?!": self = .ahead(.not)
			case "?<=": self = .behind(.equal)
			case "?<!": self = .behind(.not)
			default: return nil
			}
		}
		
		public enum Negation: String {
			///!
			case not = "!"
			///=
			case equal = "="
		}
	}
}
