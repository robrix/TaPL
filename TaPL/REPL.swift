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

func repl<T>(parser: Combinator<T>.FunctionType, map: T -> ()) {
	while let line = prompt() {
		if line == ":exit" { break }

		if let (term, rest) = parser(input: line) {
			map(term)
		} else {
			println("onoes")
		}
	}
}
