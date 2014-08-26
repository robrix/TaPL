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
