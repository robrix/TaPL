//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Term {
	func destructure() -> DestructuredTerm {
		switch self {
		case .True: return .True
		case .False: return .False
		case .Zero: return .Zero

		case let .IsZero(x): return .IsZero(x.value)
		case let .Successor(x): return .Successor(x.value)
		case let .Predecessor(x): return .Predecessor(x.value)

		case let .If(x, y, z): return .If(x.value, y.value, z.value)
		}
	}
}

enum DestructuredTerm {
	case True
	case False
	case Zero

	case IsZero(Term)
	case Successor(Term)
	case Predecessor(Term)

	case If(Term, Term, Term)
}
