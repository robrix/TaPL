//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Type: Equatable, Printable {
	// MARK: Base types

	case Bool
	case String
	case Integer
	case Double
	case Unit

	case Function(Box<Type>, Box<Type>)

	var functionType: (Type, Type)? {
		switch self {
		case let .Function(t, u):
			return (t.value, u.value)
		default:
			return nil
		}
	}


	// MARK: Printable

	public var description: Swift.String {
		switch self {
		case Bool:
			return "Bool"
		case String:
			return "String"
		case Integer:
			return "Integer"
		case Double:
			return "Double"
		case Unit:
			return "Unit"

		case let Function(t, u):
			return "(\(t.value.description) → \(u.value.description))"
		}
	}
}

infix operator --> {}

func --> (lhs: Type, rhs: Type) -> Type {
	return .Function(Box(lhs), Box(rhs))
}


infix operator ** {}
func ** <T, U>(left: Either<T, U>, right: Either<T, U>) -> Either<T, (U, U)> {
	return left.either(Either.left, { x in
		right.either(Either.left, { y in
			.right(x, y)
		})
	})
}

func typeof(term: Term<()>, context: [(Int, Type)] = []) -> Either<String, Type> {
	let recur: Box<Term<()>> -> Either<String, Type> = { term in
		typeof(term.value, context: context)
	}

	switch term {
	case .True, .False:
		return .right(.Bool)

	case let .If(_, condition, then, otherwise):
		return recur(condition).either(Either.left, { conditionType in
			conditionType == .Bool ?
				(recur(then) ** recur(otherwise)).either(Either.left, { thenType, elseType in
					thenType == elseType ?
						.right(thenType)
					:	.left("error: branches had inequal types: \(thenType) != \(elseType)")
				})
			:	.left("error: condition had type \(conditionType) instead of Bool")
		})

	case let .Index(_, i):
		return .right(context[i].1)

	case let .Abstraction(_, t, v):
		return typeof(v.value, context: context + [(context.count, t)]).either(Either.left, {
			.right(t --> $0)
		})

	case let .Application(_, a, b):
		return recur(a).either(Either.left, {
			$0.functionType.map { parameterType, returnType in
				recur(b).either(Either.left, { argumentType in
					argumentType == parameterType ?
						.right(returnType)
					:	.left("error: argument had type \(argumentType) instead of expected type \(parameterType)")
				})
			} ?? .left("error: \(a) is not of function type")
		})
	}
}


// MARK: Equatable

public func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case (.Bool, .Bool):
		return true
	case let (.Function(x1, y1), .Function(x2, y2)) where x1 == x2 && y1 == y2:
		return true
	default:
		return false
	}
}


// MARK: Import

import Box
import Either
import Madness
import Prelude
