//  Copyright (c) 2014 Rob Rix. All rights reserved.

// The untyped calculus of booleans and numbers.

public enum Term : Equatable {
	case True
	case False
	case Zero
	case If(Box<Term>, Box<Term>, Box<Term>)
	case IsZero(Box<Term>)
	case Successor(Box<Term>)
	case Predecessor(Box<Term>)
}

public func == (lhs: Term, rhs: Term) -> Bool {
	switch (lhs, rhs) {
	case (.True, .True): return true
	case (.False, .False): return true
	case (.Zero, .Zero): return true
	default: return false
	}
}


struct Combinator<T> {
	typealias FunctionType = String -> (T, String)?
}

func literal(string: String)(input: String) -> (String, String)? {
	if startsWith(input, string) {
		return (string, input[advance(input.startIndex, countElements(string))..<string.endIndex])
	}
	return nil
}

postfix operator * {}

postfix func * <T>(combinator: String -> (T, String)?)(var input: String) -> String {
	while let result = combinator(input) {
		input = result.1
	}
	return input
}

infix operator --> {}

func --> <T>(combinator: String -> (String, String)?, map: String -> T)(input: String) -> (term: T, rest: String)? {
	if let (parsed, rest) = combinator(input) { return (term: map(parsed), rest: rest) }

	return nil
}

infix operator ++ {
	associativity right
	precedence 150
}

func ++ <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> ((T, U), String)? {
	if let (lparsed, lrest) = lhs(input) {
		if let (rparsed, rrest) = rhs(lrest) {
			return ((lparsed, rparsed), rrest)
		}
	}
	return nil
}

enum Either<L, R> {
	case Left(Box<L>)
	case Right(Box<R>)
}

func | <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (Either<T, U>, String)? {
	if let (parsed, rest) = lhs(input) { return (.Left(Box(parsed)), rest) }
	if let (parsed, rest) = rhs(input) { return (.Right(Box(parsed)), rest) }
	return nil
}



public let parseTrue = literal("true") --> { _ in Term.True }
public let parseFalse = literal("false") --> { _ in Term.False }
public let parseZero = literal("0") --> { _ in Term.Zero }

public let parseWhitespace = literal(" ")*
