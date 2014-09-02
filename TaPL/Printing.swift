//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Term : Printable {
	public var description: String {
		switch self {
		case .True: return "true"
		case .False: return "false"
		case .Zero: return "0"

		case let .Successor(x): return "succ \(x.value.description)"
		case let .Predecessor(x): return "pred \(x.value.description)"
		case let .IsZero(x): return "iszero \(x.value.description)"

		case let .If(x, y, z): return "if \(x.value.description) then \(y.value.description) else \(z.value.description)"
		}
	}
}
