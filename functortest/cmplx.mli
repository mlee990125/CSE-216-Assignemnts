type complex
(*constructors*)
val rect: float -> float -> complex
val polar: float -> float -> complex 
(*accessors*)
val re: complex -> float
val im: complex -> float
val mag: complex -> float
val ang: complex -> float
(*complex arithmetic package*)
val add: complex -> complex -> complex
val sub: complex -> complex -> complex
val mul: complex -> complex -> complex
val div: complex -> complex -> complex
val to_str: complex -> string