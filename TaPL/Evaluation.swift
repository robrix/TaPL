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
	case let .IsZero(x):
		return eval(x) == Term.Zero ? Term.True : Term.False

	case let .If(x, y, z):
		return eval(x) ? eval(y) : eval(z)

	default:
		return term
	}
}
