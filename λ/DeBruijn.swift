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

	func shift(d: Int, cutoff c: Int = 0) -> NamelessTerm {
		switch self {
		case let .Index(k) where k < c: return self
		case let .Index(k): return Index(k + d)
		case let .Abstraction(t): return Abstraction(Box(t.value.shift(d, cutoff: c + 1)))
		case let .Application(t, u): return Application(Box(t.value.shift(d, cutoff: c)), Box(u.value.shift(d, cutoff: c)))
		}
	}
}
