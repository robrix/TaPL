//  Copyright (c) 2014 Rob Rix. All rights reserved.

// Simply typed λ calculus, ch 9.

let index = %0
let application = index • %true
let abstraction = lambda(.Bool --> .Bool, application)
