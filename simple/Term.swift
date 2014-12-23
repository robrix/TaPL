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


func shift<Info>(term: Term<Info>, by: Int) -> Term<Info> {
	let walk: (Term<Info>, Int) -> Term<Info> = fix { walk in
		{ term, c in
			switch term {
			case let .True(info):
				return .True(info)
			case let .False(info):
				return .False(info)

			case let .If(info, condition, then, otherwise):
				return .If(info, condition.map { walk($0, c) }, then.map { walk($0, c) }, otherwise.map { walk($0, c) })

			case let .Index(info, n) where n >= c:
				return .Index(info, n + by)
			case let .Index(info, n):
				return .Index(info, n)
			case let .Abstraction(info, type, body):
				return .Abstraction(info, type, body.map { walk($0, c + 1) })
			case let .Application(info, a, b):
				return .Application(info, a.map { walk($0, c) }, b.map { walk($0, c) })
			}
		}
	}
	return walk(term, 0)
}


// MARK: Import

import Prelude
import Box
