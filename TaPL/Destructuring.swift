//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum DestructuredTerm {
	case True
	case False
	case Zero

	case IsZero(Term)
	case Successor(Term)
	case Predecessor(Term)

	case If(Term, Term, Term)

	init(_ term: Term) {
		switch term {
		case .True: self = .True
		case .False: self = .False
		case .Zero: self = .Zero

		case let .IsZero(x): self = .IsZero(x.value)
		case let .Successor(x): self = .Successor(x.value)
		case let .Predecessor(x): self = .Predecessor(x.value)

		case let .If(x, y, z): self = .If(x.value, y.value, z.value)
		}
	}
}
