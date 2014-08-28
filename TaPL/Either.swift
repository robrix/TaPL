//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A binary choice.
public enum Either<L, R> {
	case Left(Box<L>)
	case Right(Box<R>)

	public var left: L? {
		switch self {
		case let .Left(x): return x.value
		default: return nil
		}
	}

	public var right: R? {
		switch self {
		case let .Right(x): return x.value
		default: return nil
		}
	}
}


/// Equality of Either<L : Equatable, R : Equatable>.
public func == <L : Equatable, R : Equatable> (lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
	switch (lhs, rhs) {
	case let (.Left(x), .Left(y)) where x == y: return true
	case let (.Right(x), .Right(y)) where x == y: return true
	default: return false
	}
}
