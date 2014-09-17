//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Term : Equatable, Printable {
	case Variable(String)
	case Abstraction(String, Box<Term>)
	case Application(Box<Term>, Box<Term>)

	var description: String {
		switch self {
		case let .Variable(x): return x
		case let .Abstraction(x, y): return "\\ \(x) . \(y.value)"
		case let .Application(x, y): return "\(x.value) \(y.value)"
		}
	}
}

func == (lhs: Term, rhs: Term) -> Bool {
	return false
}

let parseOptionalWhitespace = ignore(literal(" ")*)
let parseRequiredWhitespace = ignore(literal(" ") ++ literal(" ")*)
let parseVariableTerm = parseVariable --> { Term.Variable($0) }
let parseTerm: Combinator<Term>.FunctionType = fix { parseAbstraction | parseApplication | parseVariableTerm }

let parseVariable = characterSet("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

let parseLambda = ignore(literal("\\") ++ parseOptionalWhitespace)
let parseParameter = parseVariable ++ parseOptionalWhitespace
let parseBody = ignore(literal(".")) ++ parseOptionalWhitespace ++ parseTerm ++ parseOptionalWhitespace
let parseAbstraction = (parseLambda ++ parseParameter ++ parseBody) --> { Term.Abstraction($0, Box($1)) }

let parseApplication = (parseTerm ++ parseRequiredWhitespace ++ parseTerm) --> { Term.Application(Box($0), Box($1)) }
