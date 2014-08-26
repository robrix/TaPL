//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import TaPL

class TaPLTests : XCTestCase {
	func testParsing() {
		XCTAssertTrue(parseTrue(input: "true") != nil)
	}
}
