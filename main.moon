import graphics, keyboard from love
import sin, cos, pi, abs from math

require "Global"
require "Vector2"

worldWidth = 820
worldHeight = 540

paddleWidth = worldWidth * 0.02
paddleHeight = worldHeight * 0.16

paddleRotateRadius = worldWidth * 0.4
paddleRotateCenter = Vector2 worldWidth * 0.5, worldHeight * 0.5

class Paddle
	new: =>
		@angle = 0

		@buildVectorsFromAngle!
		@size = Vector2 paddleWidth, paddleHeight

		@moveSpeed = -1.4

	buildVectorsFromAngle: =>
		@offsetVector = Vector2.fromAngle(@angle)
		-- print @offsetVector
		-- @offsetVector.x *= paddleRotateRadius
		-- @offsetVector.y *= paddleRotateRadius * 0.85
		@position = paddleRotateCenter - (@offsetVector * paddleRotateRadius)

	move: (ya, dt) =>
		@angle += (ya * dt * @moveSpeed)

		maxRotate = 1
		if @angle > maxRotate
			@angle = maxRotate
		if @angle < -maxRotate
		 	@angle = -maxRotate

		@buildVectorsFromAngle!

	getAngle: => @angle


class Ball
	new: =>
		@center = Vector2 worldWidth / 2, worldHeight / 2
		@radius = (worldWidth / worldHeight) * 6

		@acceleration = Vector2.zero!
		@velocity = Vector2.zero!
		@mass = 0.05

	applyForce: (force) =>
		@acceleration += force / @mass

	update: (dt) =>
		@velocity += @acceleration * dt
		@center += @velocity * dt

		@acceleration\set 0, 0

		if @center.x < 0
			@setVelocity Vector2 abs(@velocity.x), @velocity.y
		if @center.y < 0
			@setVelocity Vector2 @velocity.x, abs(@velocity.y)
		if @center.x > worldWidth
			@setVelocity Vector2 -abs(@velocity.x), @velocity.y
		if @center.y > worldHeight
			@setVelocity Vector2 @velocity.x, -abs(@velocity.y)


	setVelocity: (newVelocity) =>
		@velocity = newVelocity\clone!


collideCircleRectangle = (circleCenter, circleRadius, rectPosition, rectSize) ->
	-- closest = circleCenter\clone!

	-- if circleCenter.x < rectPosition.x
	-- 	closest.x = rectPosition.x
	-- elseif circleCenter.x > rectPosition.x + rectSize.x
	-- 	closest.x = rectPosition.x + rectSize.x

	-- if circleCenter.y < rectPosition.y
	-- 	closest.y = rectPosition.y
	-- elseif circleCenter.y > rectPosition.y + rectSize.y
	-- 	closest.y = rectPosition.y + rectSize.y

	-- return circleCenter\distanceToSquared(closest) < circleRadius * circleRadius

	circleDistance = Vector2 abs(circleCenter.x - rectPosition.x), abs(circleCenter.y - rectPosition.y)

	if circleDistance.x > (rectSize.x / 2) + circleRadius
		return false
	if circleDistance.y > (rectSize.y / 2) + circleRadius
		return false

	if circleDistance.x <= rectSize.x / 2
		return true
	if circleDistance.y <= rectSize.y / 2
		return true

	cornerDistanceSquared = (circleDistance - (rectSize / 2))\magnitudeSquared!
	return cornerDistanceSquared <= circleRadius * circleRadius



local playerPaddle, ball


love.load = ->
	graphics.setMode worldWidth, worldHeight, false, true, 2
	playerPaddle = Paddle!
	ball = Ball!
	ball\applyForce Vector2 -9.81, 0

projectBallOntoPaddle = ->
	paddleToBall = ball.center - playerPaddle.position
	paddleDirection = playerPaddle.offsetVector\normalized!
	projected = paddleToBall\dot(paddleDirection) * paddleDirection
	ballPos = playerPaddle.position + projected
	-- ((ball.center - playerPaddle.position)\rotate playerPaddle.angle) + playerPaddle.position
	return ballPos

love.update = (dt) ->
	ya = 0
	with keyboard
		if .isDown("w") or .isDown("up")
			ya -= 1
		if .isDown("s") or .isDown("down")
			ya += 1

	if ya != 0
		playerPaddle\move ya, dt

	ball\update dt

	ballPos = projectBallOntoPaddle!

	collides = collideCircleRectangle ballPos, ball.radius, playerPaddle.position, playerPaddle.size
	if collides
		ball\applyForce -playerPaddle.offsetVector * -9.81 * 2


love.draw = ->
	graphics.setColor 255, 255, 255
	with playerPaddle
		graphics.push!
		graphics.translate .position.x, .position.y
		graphics.rotate .angle
		graphics.rectangle "fill", .size.x / -2, .size.y / -2, .size.x, .size.y
		graphics.pop!

	with ball
		graphics.circle "fill", .center.x, .center.y, .radius, 128


	ballPos = projectBallOntoPaddle!
	graphics.setColor 255, 0, 0
	graphics.circle "fill", ballPos.x, ballPos.y, 10, 128