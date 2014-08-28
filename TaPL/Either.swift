//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A binary choice.
public enum Either<L, R> {
	case Left(Box<L>)
	case Right(Box<R>)
}
