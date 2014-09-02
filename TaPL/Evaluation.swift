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
	switch term {
	case let .IsZero(x):
		return eval(x.value) == Term.Zero ? Term.True : Term.False

	case let .If(x, y, z):
		return eval(x.value) ? eval(y.value) : eval(z.value)

	default:
		return term
	}
}
