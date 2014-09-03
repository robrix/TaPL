//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Darwin

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

while let line = prompt() {
	if line == ":exit" { break }

	if let (term, rest) = parseTerm(input: line) {
		if let value = eval(term) {
			println(value)
		} else {
			println("stuck")
		}
	} else {
		println("onoes")
	}
}
