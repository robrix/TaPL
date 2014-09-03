//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Term : BooleanType {
	public var boolValue: Bool {
		switch self {
		case .True: return true
		default: return false
		}
	}
}

extension Optional {
	func bind<U>(f: T -> U?) -> U? {
		switch self {
		case let .Some(x): return f(x)
		case .None: return nil
		}
	}
}

public func eval(term: Term) -> Term? {
	switch term.destructure() {
	// values
	case .True: return .True
	case .False: return .False
	case .Zero: return .Zero

	case let .Successor(x): return eval(x).map{ .Successor(Box($0)) } // E-Succ

	case .Predecessor(.Zero): return .Zero // E-PredZero
	case let .Predecessor(.Successor(x)) where x.value.numeric: return x.value // E-PredSucc
	case let .Predecessor(x): return eval(x).bind { eval(.Predecessor(Box($0))) } // E-Pred

	case .IsZero(.Zero): return .True // E-IsZeroZero
	case let .IsZero(.Successor(x)) where x.value.numeric: return .False // E-IsZeroSucc
	case let .IsZero(x): return eval(x).bind { eval(.IsZero(Box($0))) } // E-IsZero

	case let .If(.True, x, _): return eval(x) // E-IfTrue
	case let .If(.False, _, x): return eval(x) // E-IfFalse
	case let .If(x, y, z): return eval(x).bind { eval(.If(Box($0), Box(y), Box(z))) } // E-If

	default: return nil
	}
}
