//  Copyright (c) 2014 Rob Rix. All rights reserved.

let index = %0
let application = index • %true
let abstraction = lambda(.Bool --> .Bool, application)

let identity = lambda(.Bool, %0)

let result = abstraction • identity

println((eval(result), typeof(result)))
