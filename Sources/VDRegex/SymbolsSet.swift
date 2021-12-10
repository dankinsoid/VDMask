//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.06.2021.
//

import Foundation

extension Regex {
	
	public struct SymbolsSet: Equatable, Hashable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Codable, CustomStringConvertible {
		public typealias Element = SymbolsSet
		
		public var rawValue: [ClosedRange<Character>] {
			get { _rawValue }
			set { _rawValue = newValue.united }
		}
		
		private var _rawValue: [ClosedRange<Character>]
		
		public var pattern: String {
			"[\(isInverted ? "^" + inverted.clearString : clearString)]"
		}
		
		private var clearString: String {
			SymbolsSet.shortens[self] ?? rawValue.map {
				$0.lowerBound == $0.upperBound ? $0.lowerBound.regex : "\($0.lowerBound.regex)-\($0.upperBound.regex)"
			}.joined()
		}
		
		public var isInverted: Bool {
			rawValue.count > 1 && rawValue[0].lowerBound == .first && rawValue.last?.upperBound == .last
		}
		
		public var inverted: SymbolsSet {
			SymbolsSet(
				exact: _rawValue.reduce(into: [Character.first...Character.last]) { result, range in
					let i = result.count - 1
					if let next = range.upperBound.next {
						result.append(next...result[result.count - 1].upperBound)
					}
					if let prev = range.lowerBound.prev {
						result[i] = result[i].lowerBound...prev
					} else {
						result.removeLast()
					}
				}
			)
		}
		
		public var description: String { pattern }
		
		public init(rawValue: [ClosedRange<Character>]) {
			self = SymbolsSet(exact: rawValue.united)
		}
		
		private init(exact raw: [ClosedRange<Character>]) {
			_rawValue = raw
		}
		
		public init() {
			_rawValue = []
		}
		
		public init(arrayLiteral elements: Regex.SymbolsSet...) {
			self = SymbolsSet(elements)
		}
		
		public init(stringLiteral value: StringLiteralType) {
			self = SymbolsSet(value)
		}
		
		public init(_ elements: [SymbolsSet]) {
			self = SymbolsSet(rawValue: elements.reduce(into: []) { $0 += $1._rawValue })
		}
		
		public init(_ string: String) {
			_rawValue = string.map { $0...$0 }.united
		}
		
		public init(pattern: String) throws {
			guard pattern.hasPrefix("["), pattern.hasSuffix("]") else {
				throw RegexScanError.stringTooShort
			}
			let string = String(pattern.dropFirst().dropLast())
			if let const = SymbolsSet.constants[string] {
				self = const
			} else {
				var context = SymbolsSetParser.Context(index: string.startIndex)
				try SymbolsSetParser(parseConstants: false).parse(string: string, context: &context)
				if context.index < pattern.endIndex {
					throw ParserError.incorrectPattern
				}
				self = context.set
			}
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let pattern = try container.decode(String.self)
			do {
				self = try SymbolsSet(pattern: pattern)
			} catch {
				throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid pattern \(pattern)", underlyingError: error))
			}
		}
		
		public mutating func formUnion(_ other: __owned Regex.SymbolsSet) {
			rawValue = rawValue + other.rawValue
		}
		
		public func union(_ other: Regex.SymbolsSet) {
			rawValue = rawValue + other.rawValue
		}

//		public mutating func formIntersection(_ other: Regex.SymbolsSet) {
//			var newRaw: [ClosedRange<Character>] = []
//			defer { _rawValue = newRaw }
//			var i = 0
//			for range in rawValue {
//				while i < other.rawValue.count, other.rawValue[i].upperBound < range.lowerBound {
//					i += 1
//				}
//				while i < other.rawValue.count, other.rawValue[i].upperBound <= range.upperBound {
//					newRaw.append(max(range.lowerBound, other.rawValue[i].lowerBound)...min(range.upperBound, other.rawValue[i].upperBound))
//					i += 1
//				}
//				if i < other.rawValue.count, other.rawValue[i].lowerBound <= range.upperBound {
//					newRaw.append(max(range.lowerBound, other.rawValue[i].lowerBound)...min(range.upperBound, other.rawValue[i].upperBound))
//				}
//				guard i < other.rawValue.count else {	return }
//			}
//		}
//
//		#warning("Optimize")
//		public mutating func formSymmetricDifference(_ other: __owned Regex.SymbolsSet) {
//			self = inverted.intersection(other).union(intersection(other.inverted))
//		}
		
		public func contains(_ character: Character) -> Bool {
			_rawValue.contains {
				$0.contains(character)
			}
		}
		
		public func encode(to encoder: Encoder) throws {
			try pattern.encode(to: encoder)
		}
		
		public static func +(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			lhs.union(rhs)
		}
		
		///[:alnum:] - Alphanumeric characters, [A-Za-z0-9]
		public static let alphanumeric: SymbolsSet = [.alphabetic, .digits]
		///[:alpha:] - Alphabetic characters, [A-Za-z]
		public static let alphabetic: SymbolsSet = [.uppercase, .lowercase]
		///[:blank:] - Space and tab, [ \t]
		public static let blank: SymbolsSet = " \t"
		///[:cntrl:] - Control characters, [\x00-\x1F\x7F]
		public static let control: SymbolsSet = ["\u{00}"-"\u{1F}", "\u{7F}"]
		///[:digit:] - Digits, [0-9]
		public static let digits: SymbolsSet = "0"-"9"
		///[:graph:] - Visible characters
		public static let visible: SymbolsSet = [.alphanumeric, .punctuation]
		///[:lower:] - Lowercase letters, [\x21-\x7E]
		public static let lowercase: SymbolsSet = ["a"-"z", "µ", "ß"-"ö", "ø"-"ÿ", "ā", "ă", "ą", "ć", "ĉ", "ċ", "č", "ď", "đ", "ē", "ĕ", "ė", "ę", "ě", "ĝ", "ğ", "ġ", "ģ", "ĥ", "ħ", "ĩ", "ī", "ĭ", "į", "ı", "ĳ", "ĵ", "ķ"-"ĸ", "ĺ", "ļ", "ľ", "ŀ", "ł", "ń", "ņ", "ň"-"ŉ", "ŋ", "ō", "ŏ", "ő", "œ", "ŕ", "ŗ", "ř", "ś", "ŝ", "ş", "š", "ţ", "ť", "ŧ", "ũ", "ū", "ŭ", "ů", "ű", "ų", "ŵ", "ŷ", "ź", "ż", "ž"-"ƀ", "ƃ", "ƅ", "ƈ", "ƌ"-"ƍ", "ƒ", "ƕ", "ƙ"-"ƛ", "ƞ", "ơ", "ƣ", "ƥ", "ƨ", "ƪ"-"ƫ", "ƭ", "ư", "ƴ", "ƶ", "ƹ"-"ƺ", "ƽ"-"ƿ", "ǆ", "ǉ", "ǌ", "ǎ", "ǐ", "ǒ", "ǔ", "ǖ", "ǘ", "ǚ", "ǜ"-"ǝ", "ǟ", "ǡ", "ǣ", "ǥ", "ǧ", "ǩ", "ǫ", "ǭ", "ǯ"-"ǰ", "ǳ", "ǵ", "ǹ", "ǻ", "ǽ", "ǿ", "ȁ", "ȃ", "ȅ", "ȇ", "ȉ", "ȋ", "ȍ", "ȏ", "ȑ", "ȓ", "ȕ", "ȗ", "ș", "ț", "ȝ", "ȟ", "ȡ", "ȣ", "ȥ", "ȧ", "ȩ", "ȫ", "ȭ", "ȯ", "ȱ", "ȳ"-"ȹ", "ȼ", "ȿ"-"ɀ", "ɂ", "ɇ", "ɉ", "ɋ", "ɍ", "ɏ"-"ʓ", "ʕ"-"ʯ", "ͱ", "ͳ", "ͷ", "ͻ"-"ͽ", "ΐ", "ά"-"ώ", "ϐ"-"ϑ", "ϕ"-"ϗ", "ϙ", "ϛ", "ϝ", "ϟ", "ϡ", "ϣ", "ϥ", "ϧ", "ϩ", "ϫ", "ϭ", "ϯ"-"ϳ", "ϵ", "ϸ", "ϻ"-"ϼ", "а"-"џ", "ѡ", "ѣ", "ѥ", "ѧ", "ѩ", "ѫ", "ѭ", "ѯ", "ѱ", "ѳ", "ѵ", "ѷ", "ѹ", "ѻ", "ѽ", "ѿ", "ҁ", "ҋ", "ҍ", "ҏ", "ґ", "ғ", "ҕ", "җ", "ҙ", "қ", "ҝ", "ҟ", "ҡ", "ң", "ҥ", "ҧ", "ҩ", "ҫ", "ҭ", "ү", "ұ", "ҳ", "ҵ", "ҷ", "ҹ", "һ", "ҽ", "ҿ", "ӂ", "ӄ", "ӆ", "ӈ", "ӊ", "ӌ", "ӎ"-"ӏ", "ӑ", "ӓ", "ӕ", "ӗ", "ә", "ӛ", "ӝ", "ӟ", "ӡ", "ӣ", "ӥ", "ӧ", "ө", "ӫ", "ӭ", "ӯ", "ӱ", "ӳ", "ӵ", "ӷ", "ӹ", "ӻ", "ӽ", "ӿ", "ԁ", "ԃ", "ԅ", "ԇ", "ԉ", "ԋ", "ԍ", "ԏ", "ԑ", "ԓ", "ԕ", "ԗ", "ԙ", "ԛ", "ԝ", "ԟ", "ԡ", "ԣ", "ԥ", "ԧ", "ԩ", "ԫ", "ԭ", "ԯ", "ՠ"-"ֈ", "ა"-"ჺ", "ჽ"-"ჿ", "ᏸ"-"ᏽ", "ᲀ"-"ᲈ", "ᴀ"-"ᴫ", "ᵫ"-"ᵷ", "ᵹ"-"ᶚ", "ḁ", "ḃ", "ḅ", "ḇ", "ḉ", "ḋ", "ḍ", "ḏ", "ḑ", "ḓ", "ḕ", "ḗ", "ḙ", "ḛ", "ḝ", "ḟ", "ḡ", "ḣ", "ḥ", "ḧ", "ḩ", "ḫ", "ḭ", "ḯ", "ḱ", "ḳ", "ḵ", "ḷ", "ḹ", "ḻ", "ḽ", "ḿ", "ṁ", "ṃ", "ṅ", "ṇ", "ṉ", "ṋ", "ṍ", "ṏ", "ṑ", "ṓ", "ṕ", "ṗ", "ṙ", "ṛ", "ṝ", "ṟ", "ṡ", "ṣ", "ṥ", "ṧ", "ṩ", "ṫ", "ṭ", "ṯ", "ṱ", "ṳ", "ṵ", "ṷ", "ṹ", "ṻ", "ṽ", "ṿ", "ẁ", "ẃ", "ẅ", "ẇ", "ẉ", "ẋ", "ẍ", "ẏ", "ẑ", "ẓ", "ẕ"-"ẝ", "ẟ", "ạ", "ả", "ấ", "ầ", "ẩ", "ẫ", "ậ", "ắ", "ằ", "ẳ", "ẵ", "ặ", "ẹ", "ẻ", "ẽ", "ế", "ề", "ể", "ễ", "ệ", "ỉ", "ị", "ọ", "ỏ", "ố", "ồ", "ổ", "ỗ", "ộ", "ớ", "ờ", "ở", "ỡ", "ợ", "ụ", "ủ", "ứ", "ừ", "ử", "ữ", "ự", "ỳ", "ỵ", "ỷ", "ỹ", "ỻ", "ỽ", "ỿ"-"ἇ", "ἐ"-"ἕ", "ἠ"-"ἧ", "ἰ"-"ἷ", "ὀ"-"ὅ", "ὐ"-"ὗ", "ὠ"-"ὧ", "ὰ"-"ώ", "ᾀ"-"ᾇ", "ᾐ"-"ᾗ", "ᾠ"-"ᾧ", "ᾰ"-"ᾴ", "ᾶ"-"ᾷ", "ι", "ῂ"-"ῄ", "ῆ"-"ῇ", "ῐ"-"ΐ", "ῖ"-"ῗ", "ῠ"-"ῧ", "ῲ"-"ῴ", "ῶ"-"ῷ", "ℊ", "ℎ"-"ℏ", "ℓ", "ℯ", "ℴ", "ℹ", "ℼ"-"ℽ", "ⅆ"-"ⅉ", "ⅎ", "ↄ", "ⰰ"-"ⱞ", "ⱡ", "ⱥ"-"ⱦ", "ⱨ", "ⱪ", "ⱬ", "ⱱ", "ⱳ"-"ⱴ", "ⱶ"-"ⱻ", "ⲁ", "ⲃ", "ⲅ", "ⲇ", "ⲉ", "ⲋ", "ⲍ", "ⲏ", "ⲑ", "ⲓ", "ⲕ", "ⲗ", "ⲙ", "ⲛ", "ⲝ", "ⲟ", "ⲡ", "ⲣ", "ⲥ", "ⲧ", "ⲩ", "ⲫ", "ⲭ", "ⲯ", "ⲱ", "ⲳ", "ⲵ", "ⲷ", "ⲹ", "ⲻ", "ⲽ", "ⲿ", "ⳁ", "ⳃ", "ⳅ", "ⳇ", "ⳉ", "ⳋ", "ⳍ", "ⳏ", "ⳑ", "ⳓ", "ⳕ", "ⳗ", "ⳙ", "ⳛ", "ⳝ", "ⳟ", "ⳡ", "ⳣ"-"ⳤ", "ⳬ", "ⳮ", "ⳳ", "ⴀ"-"ⴥ", "ⴧ", "ⴭ", "ꙁ", "ꙃ", "ꙅ", "ꙇ", "ꙉ", "ꙋ", "ꙍ", "ꙏ", "ꙑ", "ꙓ", "ꙕ", "ꙗ", "ꙙ", "ꙛ", "ꙝ", "ꙟ", "ꙡ", "ꙣ", "ꙥ", "ꙧ", "ꙩ", "ꙫ", "ꙭ", "ꚁ", "ꚃ", "ꚅ", "ꚇ", "ꚉ", "ꚋ", "ꚍ", "ꚏ", "ꚑ", "ꚓ", "ꚕ", "ꚗ", "ꚙ", "ꚛ", "ꜣ", "ꜥ", "ꜧ", "ꜩ", "ꜫ", "ꜭ", "ꜯ"-"ꜱ", "ꜳ", "ꜵ", "ꜷ", "ꜹ", "ꜻ", "ꜽ", "ꜿ", "ꝁ", "ꝃ", "ꝅ", "ꝇ", "ꝉ", "ꝋ", "ꝍ", "ꝏ", "ꝑ", "ꝓ", "ꝕ", "ꝗ", "ꝙ", "ꝛ", "ꝝ", "ꝟ", "ꝡ", "ꝣ", "ꝥ", "ꝧ", "ꝩ", "ꝫ", "ꝭ", "ꝯ", "ꝱ"-"ꝸ", "ꝺ", "ꝼ", "ꝿ", "ꞁ", "ꞃ", "ꞅ", "ꞇ", "ꞌ", "ꞎ", "ꞑ", "ꞓ"-"ꞕ", "ꞗ", "ꞙ", "ꞛ", "ꞝ", "ꞟ", "ꞡ", "ꞣ", "ꞥ", "ꞧ", "ꞩ", "ꞯ", "ꞵ", "ꞷ", "ꞹ", "ꞻ", "ꞽ", "ꞿ", "ꟃ", "ꟈ", "ꟊ", "ꟶ", "ꟺ", "ꬰ"-"ꭚ", "ꭠ"-"ꭨ", "ꭰ"-"ꮿ", "ﬀ"-"ﬆ", "ﬓ"-"ﬗ", "ａ"-"ｚ", "𐐨"-"𐑏", "𐓘"-"𐓻", "𐳀"-"𐳲", "𑣀"-"𑣟", "𖹠"-"𖹿", "𝐚"-"𝐳", "𝑎"-"𝑔", "𝑖"-"𝑧", "𝒂"-"𝒛", "𝒶"-"𝒹", "𝒻", "𝒽"-"𝓃", "𝓅"-"𝓏", "𝓪"-"𝔃", "𝔞"-"𝔷", "𝕒"-"𝕫", "𝖆"-"𝖟", "𝖺"-"𝗓", "𝗮"-"𝘇", "𝘢"-"𝘻", "𝙖"-"𝙯", "𝚊"-"𝚥", "𝛂"-"𝛚", "𝛜"-"𝛡", "𝛼"-"𝜔", "𝜖"-"𝜛", "𝜶"-"𝝎", "𝝐"-"𝝕", "𝝰"-"𝞈", "𝞊"-"𝞏", "𝞪"-"𝟂", "𝟄"-"𝟉", "𝟋", "𞤢"-"𞥃"]
		///[:print:] - Visible characters and the space character
		public static let print: SymbolsSet = [.visible, " "]//["\u{20}"-"\u{7E}"]
		///[:punct:] - Punctuation characters, [!"#$%&'()*+,./:;<=>?@\^_`{|}~-]
		public static let punctuation: SymbolsSet = "!\"#$%&'()*+,./:;<=>?@\\^_`{|}~-"
		///[:space:] - Whitespace characters, [ \t\r\n\v\f]
		public static let whitespaces: SymbolsSet = [" ", "\u{9}"-"\u{C}"]
		///[:upper:] - Uppercase letters, [A-Z]
		public static let uppercase: SymbolsSet = "A"-"Z"
		///[:xdigit:] - Hexadecimal digits, [A-Fa-f0-9]
		public static let hex: SymbolsSet = ["A"-"F", "a"-"f", "0"-"9"]
		
		public static var constants: [String: SymbolsSet] = [
			"[:alnum:]": .alphanumeric,
			"[:alpha:]": .alphabetic,
			"[:blank:]": .blank,
			"[:cntrl:]": .control,
			"[:graph:]": .visible,
			"[:lower:]": .lowercase,
			"[:print:]": .print,
			"[:punct:]": .punctuation,
			"[:space:]": .whitespaces,
			"[:upper:]": .uppercase,
			"[:xdigit:]": .hex
		]
		
		public static var shortens: [SymbolsSet: String] {
			Dictionary(constants.map { ($0.value, $0.key) }, uniquingKeysWith: { _, p in p })
		}
		static var constantsLenghts: Set<Int> { Set(constants.map { $0.key.count }) }
	}
}

public func -(_ lhs: Character, _ rhs: Character) -> Regex.SymbolsSet {
	Regex.SymbolsSet(rawValue: [lhs...rhs])
}

public prefix func ^(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	rhs.inverted
}

extension Character {
	static var first: Character { Character(Unicode.Scalar.first) }
	static var last: Character { Character(Unicode.Scalar.last) }
	
	var prev: Character? {
		unicodeScalars.first.flatMap { $0.value > 0 ? UnicodeScalar($0.value - 1).map { Character($0) } : nil }
	}
	var next: Character? {
		unicodeScalars.first.flatMap { UnicodeScalar($0.value + 1).map { Character($0) } }
	}
}

extension Unicode.Scalar {
	public static var first: Unicode.Scalar { Unicode.Scalar(0) }
	public static var last: Unicode.Scalar { "\u{10FFFF}" }
}

extension Collection where Element == ClosedRange<Character> {
	
	var united: [ClosedRange<Character>] {
		guard count > 1 else { return Array(self) }
		return sorted(by: { $0.lowerBound < $1.lowerBound }).reduce(into: []) { partialResult, range in
			if let upper = partialResult.last?.upperBound, upper >= range.lowerBound {
				if range.upperBound > upper {
					partialResult[partialResult.count - 1] = partialResult[partialResult.count - 1].lowerBound...range.upperBound
				}
			} else {
				partialResult.append(range)
			}
		}
	}
}

private extension Character {
	static var nonPrintable: [Character: String] {
		[
			"\0": "\\0",
			"\t": "\\t",
			"\n": "\\n",
			"\u{B}": "\\v",
			"\u{C}": "\\f",
			"\r": "\\r",
			"\\": "\\\\",
			"-": "\\-",
			"]": "\\]"
		]
	}
	
	var regex: String {
		if let nonPrintable = Character.nonPrintable[self] {
			return nonPrintable
		}
		if isASCII {
			return String(self)
		}
		guard let us = unicodeScalars.first else { return String(self) }
		if us.value < 256 {
			return "\\x" + String(format: "%02X", us.value)
		}
		return "\\u" + String(format: "%04X", us.value)
	}
}
