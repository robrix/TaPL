//  Copyright (c) 2014 Rob Rix. All rights reserved.

public func readline(handle: UnsafeMutablePointer<FILE>) -> String? {
	var line: UnsafeMutablePointer<CChar> = nil
	var length: UInt = 0
	let result = getline(&line, &length, handle)
	return String.fromCString(line)
}

public func prompt(input: UnsafeMutablePointer<FILE>) -> String? {
	print("> ")
	return readline(input)
}

public func repl<T>(parser: Parser<T>.Function, map: T -> ()) {
	while let line = prompt(stdin) {
		if line == ":exit\n" { break }

		if let (term, rest) = parser(line) {
			map(term)
		} else {
			println("onoes")
		}
	}
}


// MARK: - Imports

import Darwin
import Madness
