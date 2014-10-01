//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum NamelessTerm<Info> {
	case Index(Box<Info>, Int)
	case Abstraction(Box<Info>, Box<NamelessTerm>)
	case Application(Box<Info>, Box<NamelessTerm>, Box<NamelessTerm>)

	var description: String {
		switch self {
		case let .Index(_, i): return "\(i)"
		case let .Abstraction(_, t): return "\\. \(t.value.description)"
		case let .Application(_, t, u): return "\(t.value) \(u.value)"
		}
	}

	func shift(d: Int, cutoff c: Int = 0) -> NamelessTerm {
		switch self {
		case let .Index(_, k) where k < c: return self
		case let .Index(info, k): return Index(info, k + d)
		case let .Abstraction(info, t): return Abstraction(info, Box(t.value.shift(d, cutoff: c + 1)))
		case let .Application(info, t, u): return Application(info, Box(t.value.shift(d, cutoff: c)), Box(u.value.shift(d, cutoff: c)))
		}
	}

	func substitute(s: NamelessTerm, forIndex j: Int) -> NamelessTerm {
		switch self {
		case let .Index(_, k) where k == j: return s
		case let .Index(_, k): return self
		case let .Abstraction(info, t): return .Abstraction(info, Box(t.value.substitute(s.shift(1), forIndex: j + 1)))
		case let .Application(info, t, u): return .Application(info, Box(t.value.substitute(s, forIndex: j)), Box(u.value.substitute(s, forIndex: j)))
		}
	}
}
