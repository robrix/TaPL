//  Copyright (c) 2014 Rob Rix. All rights reserved.

infix operator • {}
func • (lhs: Term<()>, rhs: Term<()>) -> Term<()> {
	return .Application(Box(()), Box(lhs), Box(rhs))
}

prefix operator % {}

prefix func %(x: Int) -> Term<()> {
	return Term.Index(Box(()), x)
}

func lambda(x: Term<()>) -> Term<()> {
	return Term.Abstraction(Box(()), Box(x))
}


enum Term<Info> {
	case Index(Box<Info>, Int)
	case Abstraction(Box<Info>, Box<Term>)
	case Application(Box<Info>, Box<Term>, Box<Term>)
}
