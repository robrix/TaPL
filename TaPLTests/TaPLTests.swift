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

	func testParseTerm() {
		XCTAssertTrue(parseTerm(input: "true")?.term == Term.True)
	}

	func testParseWhitespace() {
		XCTAssertTrue(parseWhitespace("   f")?.rest == "f")
	}

	func testParseIsZero() {
		let parsed = parseIsZero(input: "iszero true")
		println(parsed)
		println(parsed?.term)
		XCTAssertTrue(parseIsZero(input: "iszero true")?.term == Term.IsZero(Box(Term.True)))
	}
}
