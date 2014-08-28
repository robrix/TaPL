//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import TaPL

class TaPLTests : XCTestCase {
	func testParseTrue() {
		let result = parseTrue(input: "true")
		XCTAssertTrue(result?.term == Term.True)
	}
}
