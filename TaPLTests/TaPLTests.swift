//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import TaPL

class TaPLTests : XCTestCase {
	func testParseTrue() {
		let result = parseTrue(input: "true")
		XCTAssertTrue(result?.term == Term.True)
	}

	func testParseConstant() {
		XCTAssertTrue(parseConstant(input: "true")?.term.left?.left == Term.True)
		XCTAssertTrue(parseConstant(input: "false")?.term.left?.right == Term.False)
		XCTAssertTrue(parseConstant(input: "0")?.term.right == Term.Zero)
	}
}
