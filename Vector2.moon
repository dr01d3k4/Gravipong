import sqrt, cos, sin, random, pi, atan2, rad, deg, acos from math

export class Vector2
	--------------------------------------------------
	-- CONSTRUCTOR
	--------------------------------------------------

	-- Creates a new Vector2 from x, y or a table {x, y}
	new: (x = 0, y = 0) =>
		if type(x) == "table" then
			@x = x.x or x[1] or 0
			@y = x.y or x[2] or 0
		else
			-- assert type(x) == "number", "x component must be a number"
			-- assert type(y) == "number", "y component must be a number"
			@x = x
			@y = y

	--------------------------------------------------
	-- METHODS
	--------------------------------------------------

	-- Takes same parameters as constructor, works on self
	set: (x = @x, y = @y) =>
		if type(x) == "table" and #x == 2 then
			@x = x[1]
			@y = x[2]
		else
			-- assert type(x) == "number", "x component must be a number"
			-- assert type(y) == "number", "y component must be a number"
			@x = x
			@y = y
		@

	-- Returns the individual components
	getComponents: => @x, @y

	-- Returns components as a table
	getTable: => {@x, @y}

	-- Returns a new Vector2 with same x and y components
	clone: => Vector2 @x, @y

	-- Returns the magnitude of the vector
	magnitude: => sqrt @x^2 + @y^2
	getMagnitude: => @magnitude!
	length: => @magnitude!
	getLength: => @magnitude!

	-- Returns the magnitude of the vector squared
	magnitudeSquared: => @x^2 + @y^2
	getMagnitudeSquared: => @magnitudeSquared!
	lengthSquared: => @magnitudeSquared!
	getLengthSquared: => @magnitudeSquared!

	-- Calculates the distance between two vectors
	distanceTo: (v) =>
		-- assert type(v) == Vector2, "Can only find the distance between Vector2s"
		(@ - v)\magnitude!
	lengthTo: (v) => @distanceTo v

	-- Calculates the distance between two vectors squared
	distanceToSquared: (v) =>
		-- assert type(v) == Vector2, "Can only find the distance between Vector2s"
		(@ - v)\magnitudeSquared!
	lengthToSquared: (v) => @lengthToSquared v

	-- Normalize the vector. Returns self
	normalize: =>
		mag = @magnitude!
		if mag != 0
			@div mag
		@

	-- Returns a clone of the vector normalized
	normalized: =>
		mag = @magnitude!
		if mag != 0
			Vector2 @x / mag, @y / mag
		else
			@clone!

	-- Sets the magnitude of the vector to len. Returns self
	setMagnitude: (newMag) =>
		-- assert type(newMag) == "number", "Magnitude must be a number"
		@normalize!
		@mul newMag
		@
	setLength: (newMag) => @setMagnitude newMag

	-- Returns a new vector in the direction of self with new magnitude
	magnitudeSetTo: (newMag) ->
		-- assert type(newMag) == "number", "Length must be a number"
		mag = @magnitude!
		Vector2 (@x / mag) * newMag, (@y / mag) * newMag
	lengthSetTo: => @magnitudeSetTo newMag

	-- If the length is more than len then sets length to len. Returns self
	limit: (maxMag) =>
		-- assert type(len) == "number", "Magnitude must be a number"
		if @magnitudeSquared! > maxMag ^ 2 then @setMagnitude maxMag
		@

	-- If the length is more than len, then returns a new vector in same direction with length len, else clones current
	limitedTo: (maxMag) =>
		-- assert type(maxMag) == "number", "Length must be a number"
		return @magnitudeSetTo maxMag if @magnitudeSquared! > maxMag ^ 2 else @clone!

	-- Dot product
	dot: (v) =>
		-- assert type(v) == Vector2, "Can only calculate dot product on Vector2"
		@x * v.x + @y * v.y

	-- Adds v to this vector. Returns self
	add: (v) =>
		-- assert type(v) == Vector2, "Can only add Vector2s"
		@x += v.x
		@y += v.y
		@

	-- Subtracts v from this vector. Returns self
	sub: (v) =>
		-- assert type(v) == Vector2, "Can only subtract Vector2s"
		@x -= v.x
		@y -= v.y
		@

	-- Multiplies the vector by a scalar. Returns self
	mul: (s) =>
		-- assert type(s) == "number", "Can only multiply a Vector2 by a scalar"
		@x *= s
		@y *= s
		@
	mult: (s) => @mul s
	multiplyBy: (s) => @mul s

	-- Returns the vector multiplied by a scalar
	multipliedBy: (s) =>
		-- assert type(s) == "number", "Can only multiply a Vector2 by a scalar"
		@clone!\multiplyBy s

	-- Divides the vector by a scalar. Returns self
	div: (s) =>
		-- assert type(s) == "number", "Can only divide a Vector2 by a scalar"
		@x /= s
		@y /= s
		@
	divideBy: (s) => @div s

	-- Returns the vector divided by a scalar
	dividedBy: (s) =>
		-- assert type(s) == "number", "Can only divide a Vector2 by a scalar"
		@clone!\divideBy s

	-- Inverts each component of the vector. Returns self
	negate: => @mul -1

	-- Returns a clone of self negated
	negated: => @clone!\mul -1

	-- Returns true if the components of the vectors are equal
	equals: (v) => return @ == v

	-- Returns true if the magnitude of the vector is shorter than the scalar or magnitude of v
	shorterThan: (v) =>
		if type v == "number"
			@magnitudeSquared < v * v
		else
			@ < v

	-- Returns true if the magnitude of the vector is shorter than or equal to the scalar or magnitude of v
	shorterThanOrEqualTo: (v) =>
		if type v == "number"
			@magnitudeSquared <= v * v
		else
			@ <= v

	longerThan: (v) => not @shorterThanOrEqualTo v
	longerThanOrEqualTo: (v) => not @shorterThan v

	-- Returns the angle of the vector in radians where:
	-- 0 or 360 degrees, 0 or 2pi radians = right
	-- 90 degrees, pi / 2 radians = up
	-- 180 degrees, pi radians = left
	-- 270 degrees, 3pi / 2 radians = down
	angle: =>
		a = -1 * atan2 -@y, @x
		if a < 0 then a = (2 * pi) + a
		a
	heading: => @angle!
	angleDegrees: => deg @angle!
	headingDegrees: => @angleDegrees!

	-- Rotates the vector by an angle in radians
	rotate: (angle) =>
		-- print "Rotating by #{angle}, #{type angle}"
		-- assert type(angle) == "number", "Can only rotate by a number"
		@x, @y = (@x * cos angle) - (@y * sin angle), (@x * sin angle) + (@y * cos angle)
		@
	rotateDegrees: (angle) => @rotate rad angle

	-- Lerps the vector to v by am (between 0 and 1). Returns self
	lerp: (v, am) =>
		-- assert type(v) == Vector2, "Can only lerp Vector2s"
		-- assert type(am) == "number", "Amount needs to be a number"
		@x += (v.x - @x) * am
		@y += (v.y - @y) * am
		@

	-- Returns a new vector of self lerped to v by am
	lerpedTo: (v, am) =>
		-- assert type(v) == Vector2, "Can only lerp Vector2s"
		-- assert type(am) == "number", "Amount needs to be a number"
		@clone! + ((v - @) * am)

	-- Returns the angle between two vectors
	angleTo: (v) =>
		-- assert type(v) == Vector2, "Can only find the angle between Vector2s"
		d = @dot v
		v1Mag = @magnitude!
		v2Mag = v\magnitude!
		amt = dot / (v1Mag * v2Mag)
		if amt <= -1
			pi
		elseif amt > 1
			0
		else
			acos amt
	angleToDegrees: (v) => deg @angleTo v

	--------------------------------------------------
	-- METAMETHODS
	--------------------------------------------------

	-- Returns a string representation of the vector
	__tostring: => "(%.3f, %.3f)"\format @x, @y -- "(#{@x}, #{@y})"

	-- Returns the vectors added together
	__add: (v) =>
		-- assert type(@) == Vector2 and type(v) == Vector2, "Can only add Vector2s"
		Vector2 @x + v.x, @y + v.y

	-- Returns the vectors subtracted from each other
	__sub: (v) =>
		-- assert type(@) == Vector2 and type(v) == Vector2, "Can only subtract Vector2s"
		Vector2 @x - v.x, @y - v.y

	-- Returns the vector multiplied by a scalar
	__mul: (s) =>
		if type(@) == Vector2 and type(s) == "number"
			Vector2 @x * s, @y * s
		elseif type(@) == "number" and type(s) == Vector2
			Vector2 @ * s.x, @ * s.y
		-- else
			-- assert false, "Can only multiply a Vector2 by a scalar"

	-- Returns a vector divided by a scalar
	__div: (s) =>
		if type(@) == Vector2 and type(s) == "number"
			Vector2 @x / s, @y / s
		-- else
			-- assert false, "Can only divide a Vector2 by a scalar"

	-- Returns the vector * -1
	__unm: => @ * -1

	-- Performs tostring on both sides of the concatenation
	__concat: (o) => tostring(@)..tostring(o)

	-- Returns true if the the components of the vectors are the same
	__eq: (v) => @x == v.x and @y == v.y

	-- Returns true if self magnitude < other magnitude
	__lt: (v) => @magnitudeSquared! < v\magnitudeSquared!

	-- Returns true if self magnitude <= other magnitude
	__le: (v) => @magnitudeSquared! <= v\magnitudeSquared!

	--------------------------------------------------
	-- CLASS METHODS
	--------------------------------------------------

	-- Creates a new vector from a random angle
	random: -> Vector2.fromAngle random! * pi * 2

	-- Creates a vector from an angle where:
	-- 0 or 360 degrees, 0 or 2pi radians = right
	-- 90 degrees, pi / 2 radians = up
	-- 180 degrees, pi radians = left
	-- 270 degrees, 3pi / 2 radians = down
	fromAngle: (angle) -> Vector2 cos(angle), sin(angle)
	fromAngleRadians: (angle) -> Vector2 cos(angle), sin(angle)
	fromAngleDegrees: (angle) -> 
		angle = rad angle
		Vector2 cos(angle), sin(angle)

	-- Returns the distance between two vectors
	distanceBetween: (v1, v2) ->
		-- assert type(v1) == Vector2 and type(v2) == Vector2, "Can only find the distance between Vector2s"
		(v2 - v1)\magnitude!

	-- Returns the distance between two vectors squared
	distanceBetweenSquared: (v1, v2) ->
		-- assert type(v1) == Vector2 and type(v2) == Vector2, "Can only find the distance between Vector2s"
		(v2 - v1)\magnitudeSquared!

	-- Returns the angle between two vectors
	angleBetween: (v1, v2) ->
		-- assert type(v1) == Vector2 and type(v2) == Vector2, "Can only find the angle between Vector2s"
		v1\angleTo v2
	angleBetweenDegrees: (v1, v2) ->
		-- assert type(v1) == Vector2 and type(v2) == Vector2, "Can only find the angle between Vector2s"
		deg v1\angleTo v2

	-- Returns a (0, 0) Vector2
	zero: -> Vector2 0, 0