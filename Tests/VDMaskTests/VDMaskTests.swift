import XCTest
@testable import VDMask

final class VDMaskTests: XCTestCase {
	
	static var allTests = [
		("testRegex", testRegex)
	]
	
	func testRegex() {
//		let regex0 = Regex {
//			["A"-"Z", 0-9, "a"-"z", "._%+-"]+
//			"@"
//			["A"-"Z", 0-9, "a"-"z", "."]+
//			"."
//			Regex["A"-"Z", "a"-"z"].count(2...64)
//		}
//		XCTAssert(regex0.value == "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.]+\\.[A-Za-z]{2,64}", regex0.value)
//		
//		let regex1 = Regex["A"-"Z", 0-9, "a"-"z", "._%+-"].repeats.string("@")["A"-"Z", 0-9, "a"-"z", "."]+.string(".")["A"-"Z", "a"-"z"].count(2...64)
//		XCTAssert(regex1.value == "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.]+\\.[A-Za-z]{2,64}", regex1.value)
//		
//		Regex[.alphanumeric, "._%+-"].string("@")[.alphanumeric, "."].string(".")[.alphabetic].count(2...64)
//		
//		Regex("+").digit.string("-(").digit{3}.string(")-").digit{3}(Regex("-").digit{2})({2})
//		
//		
//		"+[0-9]-\\([0-9]{3}\\)-[0-9]{3}(-[0-9]{2}){2}"
//		
//		Regex("+")[0-9]("-(")[0-9]({3})(")-")[0-9]({3})(Regex("-")[0-9]({2}))({2})
//		
//		Regex {
//			"+"
//			Regex.digit
//			"-("
//			Regex[0-9].count(3)
//			")-"
//			Regex[0-9].count(3)
//			Regex.group {
//				"-"
//				Regex[0-9].count(2)
//			}.count(2)
//		}
	}
}
