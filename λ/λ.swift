//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Variable {
	let name: String
}

public enum Term : Equatable {
	case Variable(λ.Variable)
	case Abstraction(λ.Variable, Box<Term>)
	case Application(Box<Term>, Box<Term>)
}

public func == (lhs: Term, rhs: Term) -> Bool {
	return false
}



public let parseWhitespace = ignore(literal(" ")*)
public let parseVariableTerm = parseVariable --> { Term.Variable($0) }
public let parseTerm: Combinator<Term>.FunctionType = parseVariableTerm | parseAbstraction | parseApplication

public let parseVariable = parseSet("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") --> { Variable(name: $0) }
public let parseAbstraction = (ignore(literal("λ")) ++ parseVariable ++ ignore(literal(".")) ++ parseTerm) --> { Term.Abstraction($0, Box($1)) }

public let parseApplication = (parseTerm ++ parseWhitespace ++ parseTerm) --> { Term.Application(Box($0), Box($1)) }
