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
		XCTAssertTrue(parseTerm(input: "succ succ 0")?.term == Term.Successor(Box(Term.Successor(Box(Term.Zero)))))
		XCTAssertTrue(parseTerm(input: "if iszero 0 then true else false")?.term == Term.If(Box(Term.IsZero(Box(Term.Zero))), Box(Term.True), Box(Term.False)))
		XCTAssertTrue(parseTerm(input: "if true then iszero 0 else false")?.term == Term.If(Box(Term.True), Box(Term.IsZero(Box(Term.Zero))), Box(Term.False)))
		XCTAssertTrue(parseTerm(input: "if true then 0 else iszero 0")?.term == Term.If(Box(Term.True), Box(Term.Zero), Box(Term.IsZero(Box(Term.Zero)))))
	}

	func testParseWhitespace() {
		XCTAssertTrue(parseWhitespace("   f")?.rest == "f")
	}

	func testParseIsZero() {
		XCTAssertTrue(parseIsZero(input: "iszero true")?.term == Term.IsZero(Box(Term.True)))
	}

	func testParseSuccessor() {
		XCTAssertTrue(parseSuccessor(input: "succ false")?.term == Term.Successor(Box(Term.False)))
	}

	func testParsePredecessor() {
		XCTAssertTrue(parsePredecessor(input: "pred 0")?.term == Term.Predecessor(Box(Term.Zero)))
	}

	func testParseIf() {
		XCTAssertTrue(parseIf(input: "if true then false else 0")?.term == Term.If(Box(Term.True), Box(Term.False), Box(Term.Zero)))
	}
}
