//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Ubiquitous, iniquitous.
public final class Box<T> {
	let value: T

	init(_ value: T) {
		self.value = value
	}
}


/// Equality over Box<T : Equatable>
public func == <T : Equatable> (lhs: Box<T>, rhs: Box<T>) -> Bool {
	return lhs.value == rhs.value
}
