//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A hack to provide a type-generic typealias for combinator functions.
struct Combinator<T> {
	typealias FunctionType = String -> (T, String)?
}


/// Constructs a literal parser for `string`.
func literal(string: String)(input: String) -> (String, String)? {
	if startsWith(input, string) {
		return (string, input[advance(input.startIndex, countElements(string))..<string.endIndex])
	}
	return nil
}



// MARK: Repetition

postfix operator * {}

/// Constructs a repetition parser.
postfix func * <T>(combinator: Combinator<T>.FunctionType)(var input: String) -> ([T], String)? {
	var matches: [T] = []
	while let result = combinator(input) {
		matches.append(result.0)
		input = result.1
	}
	return (matches, input)
}


// MARK: Reduction

infix operator --> {}

/// Constructs a reduction parser, mapping `T` onto `U` via `map`.
func --> <T, U>(combinator: Combinator<T>.FunctionType, map: T -> U)(input: String) -> (term: U, rest: String)? {
	if let (parsed, rest) = combinator(input) { return (term: map(parsed), rest: rest) }

	return nil
}


// MARK: Concatenation

infix operator ++ {
	associativity right
	precedence 150
}

/// Constructs the concatenation of `lhs` and `rhs`.
func ++ <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (term: (T, U), rest: String)? {
	if let (lparsed, lrest) = lhs(input) {
		if let (rparsed, rrest) = rhs(lrest) {
			return ((lparsed, rparsed), rrest)
		}
	}
	return nil
}


// MARK: Alternation

/// Constructs the alternation of `lhs` and `rhs`.
func | <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (term: Either<T, U>, rest: String)? {
	if let (parsed, rest) = lhs(input) { return (.Left(Box(parsed)), rest) }
	if let (parsed, rest) = rhs(input) { return (.Right(Box(parsed)), rest) }
	return nil
}

/// Constructs the alternation of `lhs` and `rhs`, coalescing parsers of a single type.
func | <T>(lhs: Combinator<T>.FunctionType, rhs: Combinator<T>.FunctionType)(input: String) -> (term: T, rest: String)? {
	if let (parsed, rest) = lhs(input) { return (parsed, rest) }
	if let (parsed, rest) = rhs(input) { return (parsed, rest) }
	return nil
}
