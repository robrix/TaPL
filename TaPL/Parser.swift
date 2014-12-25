//  Copyright (c) 2014 Rob Rix. All rights reserved.

let digit: Parser<Int>.Function = %("0"..."9") --> { strtol($0, nil, 10) }
let whitespace: Parser<()>.Function = ignore(%" " | %"\r" | %"\t" | %"\n")+

let type: Parser<Type>.Function = fix { type in
	let boolean: Parser<Type>.Function = %"Bool" --> const(Type.Bool)
	let function: Parser<Type>.Function = ignore("(") ++ type ++ ignore("->") ++ type ++ ignore(")") --> { Type.Function(Box($0), Box($1)) }
	return boolean | function
}

public let parseTerm: Parser<Term<()>>.Function = fix { term in
	let literal = (%"true" --> const(Term.True(Box(())))) | (%"false" --> const(Term.False(Box(()))))
	let variable = digit --> { Term.Index(Box(()), $0) }
	let abstraction = ignore("λ") ++ type ++ ignore(".") ++ term --> { Term.Abstraction(Box(()), $0, Box($1)) }
	let application = ignore("(") ++ term ++ whitespace ++ term ++ ignore(")") --> { Term.Application(Box(()), Box($0), Box($1)) }
	return literal | variable | abstraction | application
}


// MARK: - Imports

import Box
import Darwin.C.stdlib
import Madness
import Prelude
