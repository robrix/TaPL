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


postfix operator * {}

/// Constructs a repetition parser.
postfix func * <T>(combinator: String -> (T, String)?)(var input: String) -> String {
	while let result = combinator(input) {
		input = result.1
	}
	return input
}

infix operator --> {}

/// Constructs a reduction parser, mapping parsed input into `T` via `map`.
func --> <T>(combinator: String -> (String, String)?, map: String -> T)(input: String) -> (term: T, rest: String)? {
	if let (parsed, rest) = combinator(input) { return (term: map(parsed), rest: rest) }

	return nil
}

infix operator ++ {
	associativity right
	precedence 150
}

/// Constructs the concatenation of `lhs` and `rhs`.
func ++ <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> ((T, U), String)? {
	if let (lparsed, lrest) = lhs(input) {
		if let (rparsed, rrest) = rhs(lrest) {
			return ((lparsed, rparsed), rrest)
		}
	}
	return nil
}

/// Constructs the alternation of `lhs` and `rhs`.
func | <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (Either<T, U>, String)? {
	if let (parsed, rest) = lhs(input) { return (.Left(Box(parsed)), rest) }
	if let (parsed, rest) = rhs(input) { return (.Right(Box(parsed)), rest) }
	return nil
}