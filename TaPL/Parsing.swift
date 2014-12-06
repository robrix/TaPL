//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A hack to provide a type-generic typealias for combinator functions.
struct Combinator<Term> {
	typealias FunctionType = (input: String) -> (term: Term, rest: String)?
}


/// Constructs a literal parser for `string`.
func literal(string: String)(input: String) -> (term: String, rest: String)? {
	if startsWith(input, string) {
		return (string, input[advance(input.startIndex, countElements(string))..<input.endIndex])
	}
	return nil
}


/// Constructs a parser for any character in `string`.
func characterSet(string: String) -> Combinator<String>.FunctionType {
	return { input in
		if input.startIndex == input.endIndex { return nil }
		if contains(string, input[input.startIndex]) {
			let advanced = advance(input.startIndex, 1)
			return (input[input.startIndex..<advanced], input[advanced..<input.endIndex])
		}
		return nil
	}
}


/// Constructs a parser which drops its results.
func ignore<T>(combinator: Combinator<T>.FunctionType) -> String -> (term: (), rest: String)? {
	return combinator --> { _ in () }
}


// MARK: Repetition

postfix operator * {}

/// Constructs a repetition parser.
postfix func * <T>(combinator: Combinator<T>.FunctionType)(var input: String) -> ([T], String)? {
	var matches: [T] = []
	while let result = combinator(input: input) {
		matches.append(result.term)
		input = result.rest
	}
	return (matches, input)
}


// MARK: Reduction

infix operator --> {
	associativity right
	precedence 170
}

/// Constructs a reduction parser, mapping `T` onto `U` via `map`.
func --> <T, U>(combinator: Combinator<T>.FunctionType, map: T -> U)(input: String) -> (term: U, rest: String)? {
	if let (parsed, rest) = combinator(input: input) { return (term: map(parsed), rest: rest) }

	return nil
}


// MARK: Concatenation

infix operator ++ {
	associativity right
	precedence 160
}

/// Constructs the concatenation of `lhs` and `rhs`.
func ++ <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (term: (T, U), rest: String)? {
	if let (lparsed, lrest) = lhs(input: input) {
		if let (rparsed, rrest) = rhs(input: lrest) {
			return ((lparsed, rparsed), rrest)
		}
	}
	return nil
}

/// Constructs the concatenation of `lhs` and `rhs`, dropping `rhs`’ input.
func ++ <T>(lhs: Combinator<T>.FunctionType, rhs: Combinator<Void>.FunctionType)(input: String) -> (term: T, rest: String)? {
	if let (lparsed, lrest) = lhs(input: input) {
		if let (rparsed: Void, rrest: String) = rhs(input: lrest) {
			return (lparsed, rrest)
		}
	}
	return nil
}

/// Constructs the concatenation of `lhs` and `rhs`, dropping `lhs`’ input.
func ++ <T>(lhs: Combinator<Void>.FunctionType, rhs: Combinator<T>.FunctionType)(input: String) -> (term: T, rest: String)? {
	if let (lparsed: Void, lrest: String) = lhs(input: input) {
		if let (rparsed, rrest) = rhs(input: lrest) {
			return (rparsed, rrest)
		}
	}
	return nil
}


// MARK: Alternation

/// Constructs the alternation of `lhs` and `rhs`.
func | <T, U>(lhs: Combinator<T>.FunctionType, rhs: Combinator<U>.FunctionType)(input: String) -> (term: Either<T, U>, rest: String)? {
	if let (parsed, rest) = lhs(input: input) { return (.Left(Box(parsed)), rest) }
	if let (parsed, rest) = rhs(input: input) { return (.Right(Box(parsed)), rest) }
	return nil
}

/// Constructs the alternation of `lhs` and `rhs`, coalescing parsers of a single type.
func | <T>(lhs: Combinator<T>.FunctionType, rhs: Combinator<T>.FunctionType)(input: String) -> (term: T, rest: String)? {
	if let (parsed, rest) = lhs(input: input) { return (parsed, rest) }
	if let (parsed, rest) = rhs(input: input) { return (parsed, rest) }
	return nil
}


// MARK: Fixpoint

/// Constructs `combinator` with a fixpoint, enabling recursive (i.e. context-free) grammars.
func fix<T, U>(body: () -> T -> U) -> T -> U {
	var _fixed: (T -> U)!
	if let fixed = _fixed { return fixed }

	_fixed = { x in
		_fixed = body()
		return _fixed(x)
	}
	return _fixed
}


// MARK: Import

import Box
import Either
