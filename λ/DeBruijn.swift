//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum NamelessTerm {
	case Index(Int)
	case Abstraction(Box<NamelessTerm>)
	case Application(Box<NamelessTerm>, Box<NamelessTerm>)

	var description: String {
		switch self {
		case let .Index(i): return "\(i)"
		case let .Abstraction(t): return "\\. \(t.value.description)"
		case let .Application(t, u): return "\(t.value) \(u.value)"
		}
	}
}
