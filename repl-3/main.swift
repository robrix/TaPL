//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Darwin

repl(parseTerm) {
	if let value = eval($0) {
		println(value)
	} else {
		println("stuck")
	}
}
