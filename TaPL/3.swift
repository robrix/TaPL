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

	// MARK: Classification
	var constant: Bool {
		switch self {
		case .True, .False, .Zero: return true
		default: return false
		}
	}

	var numeric: Bool {
		switch self.destructure() {
		case .Zero: return true
		case let .Successor(term): return term.numeric
		default: return false
		}
	}
}

/// Equality over terms.
public func == (lhs: Term, rhs: Term) -> Bool {
	switch (lhs, rhs) {
	case (.True, .True), (.False, .False), (.Zero, .Zero):
		return true
	case let (.IsZero(x), .IsZero(y)) where x == y:
		return true
	case let (.Successor(x), .Successor(y)) where x == y:
		return true
	case let (.Predecessor(x), .Predecessor(y)) where x == y:
		return true
	case let (.If(x1, y1, z1), .If(x2, y2, z2)) where x1 == x2 && y1 == y2 && z1 == z2:
		return true
	default:
		return false
	}
}

private var _parseTerm: Combinator<Term>.FunctionType!
public var parseTerm: Combinator<Term>.FunctionType {
	if let parseTerm = _parseTerm { return parseTerm }

	_parseTerm = { input in
		_parseTerm = parseConstant | parseIsZero | parseSuccessor | parsePredecessor | parseIf
		return _parseTerm(input: input)
	}
	return _parseTerm
}

public let parseTrue = literal("true") --> { _ in Term.True }
public let parseFalse = literal("false") --> { _ in Term.False }
public let parseZero = literal("0") --> { _ in Term.Zero }

public let parseConstant = parseTrue | parseFalse | parseZero

public let parseWhitespace = ignore(literal(" ")*)

public let parseIsZero = ignore(literal("iszero")) ++ parseWhitespace ++ parseTerm --> { x in Term.IsZero(Box(x)) }

public let parseSuccessor = ignore(literal("succ")) ++ parseWhitespace ++ parseTerm --> { x in Term.Successor(Box(x)) }
public let parsePredecessor = ignore(literal("pred")) ++ parseWhitespace ++ parseTerm --> { x in Term.Predecessor(Box(x)) }

public let parseCondition = ignore(literal("if")) ++ parseWhitespace ++ parseTerm
public let parseThen = ignore(literal("then")) ++ parseWhitespace ++ parseTerm
public let parseElse = ignore(literal("else")) ++ parseWhitespace ++ parseTerm
public let parseIf = (parseCondition ++ parseWhitespace ++ parseThen ++ parseWhitespace ++ parseElse) --> { (v: (Term, (Term, Term))) in Term.If(Box(v.0), Box(v.1.0), Box(v.1.1)) }
