//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum NamelessTerm {
	case Index(Int)
	case Abstraction(Box<NamelessTerm>)
	case Application(Box<NamelessTerm>, Box<NamelessTerm>)
}
