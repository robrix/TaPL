//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Term : BooleanType {
	public var boolValue: Bool {
		switch self {
		case .True: return true
		default: return false
		}
	}
}

public func eval(term: Term) -> Term {
	switch term.destructure() {
	case let .Successor(x): return .Successor(Box(eval(x))) // E-Succ

	case .Predecessor(.Zero): return .Zero // E-PredZero
	case let .Predecessor(.Successor(x)) where x.value.numeric: return x.value // E-PredSucc
	case let .Predecessor(x): return eval(.Predecessor(Box(eval(x)))) // E-Pred

	case .IsZero(.Zero): return .True // E-IsZeroZero
	case .IsZero(.Successor): return .False // E-IsZeroSucc
	case let .IsZero(x): return eval(.IsZero(Box(eval(x)))) // E-IsZero

	case let .If(.True, x, _): return eval(x) // E-IfTrue
	case let .If(.False, _, x): return eval(x) // E-IfFalse
	case let .If(x, y, z): return eval(.If(Box(eval(x)), Box(y), Box(z))) // E-If

	default: return term // .True, .False, and .Zero are already values
	}
}
