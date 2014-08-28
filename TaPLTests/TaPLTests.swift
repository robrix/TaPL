//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import TaPL

class TaPLTests : XCTestCase {
	func testParseTrue() {
		XCTAssertTrue(parseTrue(input: "true")?.term == Term.True)
	}

	func testParseConstant() {
		XCTAssertTrue(parseConstant(input: "true")?.term == Term.True)
		XCTAssertTrue(parseConstant(input: "false")?.term == Term.False)
		XCTAssertTrue(parseConstant(input: "0")?.term == Term.Zero)
	}
}
