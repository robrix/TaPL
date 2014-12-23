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

	var isValue: Bool {
		switch self {
		case Abstraction, True, False:
			return true
		default:
			return false
		}
	}

	var destructured: DestructuredTerm<Info> {
		switch self {
		case let True(info):
			return .True(info)
		case let False(info):
			return .False(info)

		case let If(info, condition, then, otherwise):
			return .If(info, condition.value, then.value, otherwise.value)

		case let Index(info, n):
			return .Index(info, n)
		case let Abstraction(info, type, body):
			return .Abstraction(info, type, body.value)
		case let Application(info, a, b):
			return .Application(info, a.value, b.value)
		}
	}
}

enum DestructuredTerm<Info> {
	case True(Box<Info>)
	case False(Box<Info>)

	case If(Box<Info>, Term<Info>, Term<Info>, Term<Info>)

	case Index(Box<Info>, Int)
	case Abstraction(Box<Info>, Type, Term<Info>)
	case Application(Box<Info>, Term<Info>, Term<Info>)
}


func shift<Info>(term: Term<Info>, by: Int, above: Int = 0) -> Term<Info> {
	return map(term, above) { info, above, n in
		.Index(Box(info), n + n >= above ? by : 0)
	}
}


func substitute<Info>(term: Term<Info>, inTerm: Term<Info>) -> Term<Info> {
	return shift(substitute(shift(term, 1), 0, inTerm), -1)
}

func substitute<Info>(term: Term<Info>, forIndex: Int, inTerm: Term<Info>) -> Term<Info> {
	return map(inTerm, forIndex) { info, index, n in
		n == index ? shift(term, index) : .Index(Box(info), n)
	}
}


func map<Info>(term: Term<Info>, c: Int, f: (Info, Int, Int) -> Term<Info>) -> Term<Info> {
	let walk: (Term<Info>, Int) -> Term<Info> = fix { walk in
		{ term, c in
			switch term {
			case .True, .False:
				return term

			case let .If(info, condition, then, otherwise):
				return .If(info, condition.map { walk($0, c) }, then.map { walk($0, c) }, otherwise.map { walk($0, c) })

			case let .Index(info, n):
				return f(info.value, c, n)
			case let .Abstraction(info, type, body):
				return .Abstraction(info, type, body.map { walk($0, c + 1) })
			case let .Application(info, a, b):
				return .Application(info, a.map { walk($0, c) }, b.map { walk($0, c) })
			}
		}
	}
	return walk(term, c)
}


func evalStep<Info>(term: Term<Info>) -> Either<Term<Info>, Term<Info>> {
	switch term.destructured {
	case let .Application(info, .Abstraction(_, _, body), operand) where operand.isValue:
		return .right(substitute(operand, body.value))
	case let .Application(info, a, b) where a.isValue:
		return evalStep(b).either(Either.left, { .right(.Application(info, Box(a), Box($0))) })
	case let .Application(info, a, b):
		return evalStep(a).either(Either.left, { .right(.Application(info, Box($0), Box(b))) })

	default:
		return .left(term)
	}
}

// MARK: Import

import Box
import Either
import Prelude
