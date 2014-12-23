//  Copyright (c) 2014 Rob Rix. All rights reserved.

let digit: Parser<Int>.Function = %("0"..."9") --> { strtol($0, nil, 10) }
let boolean: Parser<Type>.Function = %"Bool" --> const(Type.Bool)
let function: Parser<Type>.Function = ignore("(") ++ type ++ ignore("->") ++ type ++ ignore(")") --> { Type.Function(Box($0), Box($1)) }
let type: Parser<Type>.Function = boolean | function

let parseTerm: Parser<Term<()>>.Function = fix { term in
	let variable = digit --> { Term.Index(Box(()), $0) }
	let abstraction = ignore("λ") ++ type ++ ignore(".") ++ term --> { Term.Abstraction(Box(()), $0, Box($1)) }
	let application = ignore("(") ++ term ++ ignore(" ") ++ term ++ ignore(")") --> { Term.Application(Box(()), Box($0), Box($1)) }
	return variable | abstraction | application
}


// MARK: - Imports

import Box
import Darwin.C.stdlib
import Madness
import Prelude
