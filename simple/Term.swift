//  Copyright (c) 2014 Rob Rix. All rights reserved.

enum Term<Info> {
	case Index(Box<Info>, Int)
	case Abstraction(Box<Info>, Box<Term>)
	case Application(Box<Info>, Box<Term>, Box<Term>)
}
