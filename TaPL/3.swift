//  Copyright (c) 2014 Rob Rix. All rights reserved.

// The untyped calculus of booleans and numbers.

/// A term.
public enum Term : Equatable {
	// MARK: Constants
	case True
	case False
	case Zero

	// MARK: Unary
	case IsZero(Box<Term>)
	case Successor(Box<Term>)
	case Predecessor(Box<Term>)

	// MARK: Ternary
	case If(Box<Term>, Box<Term>, Box<Term>)
}

/// Equality over terms.
public func == (lhs: Term, rhs: Term) -> Bool {
	switch (lhs, rhs) {
	case (.True, .True), (.False, .False), (.Zero, .Zero): return true
	default: return false
	}
}


public let parseTrue = literal("true") --> { _ in Term.True }
public let parseFalse = literal("false") --> { _ in Term.False }
public let parseZero = literal("0") --> { _ in Term.Zero }

public let parseConstant = parseTrue | parseFalse | parseZero

public let parseWhitespace = literal(" ")*

public let parseIsZero = literal("iszero")// ++ parseTerm

public let parseTerm = parseTrue | parseFalse// | parseZero | parseWhitespace | parseIsZero
