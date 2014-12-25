//  Copyright (c) 2014 Rob Rix. All rights reserved.

import TaPL
import XCTest

final class TaPLTests : XCTestCase {
	func testREPL() {
		repl(parseTerm) {
			println(eval($0))
		}
	}
}
