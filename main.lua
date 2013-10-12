local graphics, keyboard
do
  local _obj_0 = love
  graphics, keyboard = _obj_0.graphics, _obj_0.keyboard
end
local sin, cos, pi, abs
do
  local _obj_0 = math
  sin, cos, pi, abs = _obj_0.sin, _obj_0.cos, _obj_0.pi, _obj_0.abs
end
require("Global")
require("Vector2")
local worldWidth = 820
local worldHeight = 540
local paddleWidth = worldWidth * 0.02
local paddleHeight = worldHeight * 0.16
local paddleRotateRadius = worldWidth * 0.4
local paddleRotateCenter = Vector2(worldWidth * 0.5, worldHeight * 0.5)
local Paddle
do
  local _base_0 = {
    buildVectorsFromAngle = function(self)
      self.offsetVector = Vector2.fromAngle(self.angle)
      self.position = paddleRotateCenter - (self.offsetVector * paddleRotateRadius)
    end,
    move = function(self, ya, dt)
      self.angle = self.angle + (ya * dt * self.moveSpeed)
      local maxRotate = 1
      if self.angle > maxRotate then
        self.angle = maxRotate
      end
      if self.angle < -maxRotate then
        self.angle = -maxRotate
      end
      return self:buildVectorsFromAngle()
    end,
    getAngle = function(self)
      return self.angle
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.angle = 0
      self:buildVectorsFromAngle()
      self.size = Vector2(paddleWidth, paddleHeight)
      self.moveSpeed = -1.4
    end,
    __base = _base_0,
    __name = "Paddle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Paddle = _class_0
end
local Ball
do
  local _base_0 = {
    applyForce = function(self, force)
      self.acceleration = self.acceleration + (force / self.mass)
    end,
    update = function(self, dt)
      self.velocity = self.velocity + (self.acceleration * dt)
      self.center = self.center + (self.velocity * dt)
      self.acceleration:set(0, 0)
      if self.center.x < 0 then
        self:setVelocity(Vector2(abs(self.velocity.x), self.velocity.y))
      end
      if self.center.y < 0 then
        self:setVelocity(Vector2(self.velocity.x, abs(self.velocity.y)))
      end
      if self.center.x > worldWidth then
        self:setVelocity(Vector2(-abs(self.velocity.x), self.velocity.y))
      end
      if self.center.y > worldHeight then
        return self:setVelocity(Vector2(self.velocity.x, -abs(self.velocity.y)))
      end
    end,
    setVelocity = function(self, newVelocity)
      self.velocity = newVelocity:clone()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.center = Vector2(worldWidth / 2, worldHeight / 2)
      self.radius = (worldWidth / worldHeight) * 6
      self.acceleration = Vector2.zero()
      self.velocity = Vector2.zero()
      self.mass = 0.05
    end,
    __base = _base_0,
    __name = "Ball"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Ball = _class_0
end
local collideCircleRectangle
collideCircleRectangle = function(circleCenter, circleRadius, rectPosition, rectSize)
  local circleDistance = Vector2(abs(circleCenter.x - rectPosition.x), abs(circleCenter.y - rectPosition.y))
  if circleDistance.x > (rectSize.x / 2) + circleRadius then
    return false
  end
  if circleDistance.y > (rectSize.y / 2) + circleRadius then
    return false
  end
  if circleDistance.x <= rectSize.x / 2 then
    return true
  end
  if circleDistance.y <= rectSize.y / 2 then
    return true
  end
  local cornerDistanceSquared = (circleDistance - (rectSize / 2)):magnitudeSquared()
  return cornerDistanceSquared <= circleRadius * circleRadius
end
local playerPaddle, ball
love.load = function()
  graphics.setMode(worldWidth, worldHeight, false, true, 2)
  playerPaddle = Paddle()
  ball = Ball()
  return ball:applyForce(Vector2(-9.81, 0))
end
local projectBallOntoPaddle
projectBallOntoPaddle = function()
  local paddleToBall = ball.center - playerPaddle.position
  local paddleDirection = playerPaddle.offsetVector:normalized()
  local projected = paddleToBall:dot(paddleDirection) * paddleDirection
  local ballPos = playerPaddle.position + projected
  return ballPos
end
love.update = function(dt)
  local ya = 0
  do
    if keyboard.isDown("w") or keyboard.isDown("up") then
      ya = ya - 1
    end
    if keyboard.isDown("s") or keyboard.isDown("down") then
      ya = ya + 1
    end
  end
  if ya ~= 0 then
    playerPaddle:move(ya, dt)
  end
  ball:update(dt)
  local ballPos = projectBallOntoPaddle()
  local collides = collideCircleRectangle(ballPos, ball.radius, playerPaddle.position, playerPaddle.size)
  if collides then
    return ball:applyForce(-playerPaddle.offsetVector * -9.81 * 2)
  end
end
love.draw = function()
  graphics.setColor(255, 255, 255)
  do
    graphics.push()
    graphics.translate(playerPaddle.position.x, playerPaddle.position.y)
    graphics.rotate(playerPaddle.angle)
    graphics.rectangle("fill", playerPaddle.size.x / -2, playerPaddle.size.y / -2, playerPaddle.size.x, playerPaddle.size.y)
    graphics.pop()
  end
  do
    graphics.circle("fill", ball.center.x, ball.center.y, ball.radius, 128)
  end
  local ballPos = projectBallOntoPaddle()
  graphics.setColor(255, 0, 0)
  return graphics.circle("fill", ballPos.x, ballPos.y, 10, 128)
end
