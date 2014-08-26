//  Copyright (c) 2014 Rob Rix. All rights reserved.

// The untyped calculus of booleans and numbers.

public enum Term {
	case True
	case False
	case Zero
	case If(Box<Term>, Box<Term>, Box<Term>)
	case IsZero(Box<Term>)
	case Successor(Box<Term>)
	case Predecessor(Box<Term>)
}


func literal(string: String)(input: String) -> (String, String)? {
	if startsWith(input, string) {
		return (string, input[advance(input.startIndex, countElements(string))..<string.endIndex])
	}
	return nil
}
