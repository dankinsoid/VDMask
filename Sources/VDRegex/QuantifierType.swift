//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	public enum QuantifierType: String {
		case lazy = "?", possessive = "+", greedy = ""
		
		public static var `default`: QuantifierType { .greedy }
	}
}
