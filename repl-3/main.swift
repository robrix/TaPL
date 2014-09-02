//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Foundation

func readline(handle: UnsafeMutablePointer<FILE>) -> String? {
	let getNonNewline: () -> CChar? = {
		let c = CChar(getc(handle))
		return String.fromCString([c, 0]) == "\n" ? nil : c
	}

	return String.fromCString(Array(SequenceOf(GeneratorOf(getNonNewline))))
}

func prompt() -> String? {
	print("> ")
	return readline(stdin)
}

