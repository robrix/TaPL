//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Type {
	case Bool
	case Function(Box<Type>, Box<Type>)
}

func --> (lhs: Type, rhs: Type) -> Type {
	return .Function(Box(lhs), Box(rhs))
}

func typeof<Info>(term: Term<Info>, context: [(Int, Type)] = []) -> Type {
	return Type.Bool
}
