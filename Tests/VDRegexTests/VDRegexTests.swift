import XCTest
@testable import VDRegex

final class VDRegexTests: XCTestCase {
	
	static var allTests = [
		("testRegex", testRegex)
	]
	
	func testRegex() {
		let regex0 = Regex {
			["A"..."Z", 0...9, "a"..."z", "._%+-"]+
			"@"
			["A"-"Z", 0-9, "a"-"z", "."]+
			"."
			Regex["A"-"Z", "a"-"z"].repeats(2...64)
		}
		XCTAssert(regex0.value == "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.]+\\.[A-Za-z]{2,64}", regex0.value)
		
		let regex1 = Regex["A"-"Z", 0-9, "a"-"z", "._%+-"].repeats.string("@")["A"-"Z", 0-9, "a"-"z", "."]+.string(".")["A"-"Z", "a"-"z"].repeats(2...64)
		XCTAssert(regex1.value == "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.]+\\.[A-Za-z]{2,64}", regex1.value)
	}
}
