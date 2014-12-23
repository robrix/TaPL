//  Copyright (c) 2014 Rob Rix. All rights reserved.

infix operator • {}
func • (lhs: Term<()>, rhs: Term<()>) -> Term<()> {
	return .Application(Box(()), Box(lhs), Box(rhs))
}

prefix operator % {}

prefix func %(x: Bool) -> Term<()> {
	return x ? Term.True(Box(())) : Term.False(Box(()))
}

prefix func %(x: Int) -> Term<()> {
	return Term.Index(Box(()), x)
}

func lambda(t: Type, x: Term<()>) -> Term<()> {
	return Term.Abstraction(Box(()), t, Box(x))
}


/// Nameless (De Bruijn-indexed) terms.
enum Term<Info>: Printable {
	case True(Box<Info>)
	case False(Box<Info>)

	case If(Box<Info>, Box<Term>, Box<Term>, Box<Term>)

	case Index(Box<Info>, Int)
	case Abstraction(Box<Info>, Type, Box<Term>)
	case Application(Box<Info>, Box<Term>, Box<Term>)

	var description: String {
		switch self {
		case True:
			return "true"
		case False:
			return "false"

		case let If(_, condition, then, otherwise):
			return "if \(condition) \(then) \(otherwise)"

		case let Index(_, n):
			return "\(n)"
		case let Abstraction(_, t, b):
			return "λ \(t) . \(b)"
		case let Application(_, a, b):
			return "(\(a)) \(b)"
		}
	}
}


// MARK: Import

import Box
