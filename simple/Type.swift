//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Type: Equatable {
	case Bool
	case Function(Box<Type>, Box<Type>)

	var functionType: (Type, Type)? {
		switch self {
		case let .Function(t, u):
			return (t.value, u.value)
		default:
			return nil
		}
	}
}

func --> (lhs: Type, rhs: Type) -> Type {
	return .Function(Box(lhs), Box(rhs))
}

func typeof(term: Term<()>, context: [(Int, Type)] = []) -> Type {
	let recur: Box<Term<()>> -> Type = { term in
		typeof(term.value, context: context)
	}

	switch term {
	case .True, .False:
		return .Bool

	case let .If(_, condition, then, otherwise):
		let conditionType = recur(condition)
		if conditionType == .Bool {
			let (thenType, elseType) = (recur(then), recur(otherwise))
			if thenType == elseType {
				return thenType
			} else {
				println("error: branches had inequal types: \(thenType) != \(elseType)")
			}
		} else {
			println("error: condition had type \(conditionType) instead of Bool")
		}
		return .Bool

	case let .Index(_, i):
		return context[i].1

	case let .Abstraction(_, t, v):
		return t --> typeof(v.value, context: context + [(context.count, t)])

	default:
		println("error: no idea what this is, let’s just call it Bool")
		return .Bool
	}
}


// MARK: Equatable

func == (left: Type, right: Type) -> Bool {
	switch (left, right) {
	case (.Bool, .Bool):
		return true
	case let (.Function(x1, y1), .Function(x2, y2)) where x1 == x2 && y1 == y2:
		return true
	default:
		return false
	}
}
