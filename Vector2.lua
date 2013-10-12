local sqrt, cos, sin, random, pi, atan2, rad, deg, acos
do
  local _obj_0 = math
  sqrt, cos, sin, random, pi, atan2, rad, deg, acos = _obj_0.sqrt, _obj_0.cos, _obj_0.sin, _obj_0.random, _obj_0.pi, _obj_0.atan2, _obj_0.rad, _obj_0.deg, _obj_0.acos
end
do
  local _base_0 = {
    set = function(self, x, y)
      if x == nil then
        x = self.x
      end
      if y == nil then
        y = self.y
      end
      if type(x) == "table" and #x == 2 then
        self.x = x[1]
        self.y = x[2]
      else
        self.x = x
        self.y = y
      end
      return self
    end,
    getComponents = function(self)
      return self.x, self.y
    end,
    getTable = function(self)
      return {
        self.x,
        self.y
      }
    end,
    clone = function(self)
      return Vector2(self.x, self.y)
    end,
    magnitude = function(self)
      return sqrt(self.x ^ 2 + self.y ^ 2)
    end,
    getMagnitude = function(self)
      return self:magnitude()
    end,
    length = function(self)
      return self:magnitude()
    end,
    getLength = function(self)
      return self:magnitude()
    end,
    magnitudeSquared = function(self)
      return self.x ^ 2 + self.y ^ 2
    end,
    getMagnitudeSquared = function(self)
      return self:magnitudeSquared()
    end,
    lengthSquared = function(self)
      return self:magnitudeSquared()
    end,
    getLengthSquared = function(self)
      return self:magnitudeSquared()
    end,
    distanceTo = function(self, v)
      return (self - v):magnitude()
    end,
    lengthTo = function(self, v)
      return self:distanceTo(v)
    end,
    distanceToSquared = function(self, v)
      return (self - v):magnitudeSquared()
    end,
    lengthToSquared = function(self, v)
      return self:lengthToSquared(v)
    end,
    normalize = function(self)
      local mag = self:magnitude()
      if mag ~= 0 then
        self:div(mag)
      end
      return self
    end,
    normalized = function(self)
      local mag = self:magnitude()
      if mag ~= 0 then
        return Vector2(self.x / mag, self.y / mag)
      else
        return self:clone()
      end
    end,
    setMagnitude = function(self, newMag)
      self:normalize()
      self:mul(newMag)
      return self
    end,
    setLength = function(self, newMag)
      return self:setMagnitude(newMag)
    end,
    magnitudeSetTo = function(newMag)
      local mag = self:magnitude()
      return Vector2((self.x / mag) * newMag, (self.y / mag) * newMag)
    end,
    lengthSetTo = function(self)
      return self:magnitudeSetTo(newMag)
    end,
    limit = function(self, maxMag)
      if self:magnitudeSquared() > maxMag ^ 2 then
        self:setMagnitude(maxMag)
      end
      return self
    end,
    limitedTo = function(self, maxMag)
      if self:magnitudeSquared() > maxMag ^ 2 then
        return self:magnitudeSetTo(maxMag)
      else
        return self:clone()
      end
    end,
    dot = function(self, v)
      return self.x * v.x + self.y * v.y
    end,
    add = function(self, v)
      self.x = self.x + v.x
      self.y = self.y + v.y
      return self
    end,
    sub = function(self, v)
      self.x = self.x - v.x
      self.y = self.y - v.y
      return self
    end,
    mul = function(self, s)
      self.x = self.x * s
      self.y = self.y * s
      return self
    end,
    mult = function(self, s)
      return self:mul(s)
    end,
    multiplyBy = function(self, s)
      return self:mul(s)
    end,
    multipliedBy = function(self, s)
      return self:clone():multiplyBy(s)
    end,
    div = function(self, s)
      self.x = self.x / s
      self.y = self.y / s
      return self
    end,
    divideBy = function(self, s)
      return self:div(s)
    end,
    dividedBy = function(self, s)
      return self:clone():divideBy(s)
    end,
    negate = function(self)
      return self:mul(-1)
    end,
    negated = function(self)
      return self:clone():mul(-1)
    end,
    equals = function(self, v)
      return self == v
    end,
    shorterThan = function(self, v)
      if type(v == "number") then
        return self.magnitudeSquared < v * v
      else
        return self < v
      end
    end,
    shorterThanOrEqualTo = function(self, v)
      if type(v == "number") then
        return self.magnitudeSquared <= v * v
      else
        return self <= v
      end
    end,
    longerThan = function(self, v)
      return not self:shorterThanOrEqualTo(v)
    end,
    longerThanOrEqualTo = function(self, v)
      return not self:shorterThan(v)
    end,
    angle = function(self)
      local a = -1 * atan2(-self.y, self.x)
      if a < 0 then
        a = (2 * pi) + a
      end
      return a
    end,
    heading = function(self)
      return self:angle()
    end,
    angleDegrees = function(self)
      return deg(self:angle())
    end,
    headingDegrees = function(self)
      return self:angleDegrees()
    end,
    rotate = function(self, angle)
      self.x, self.y = (self.x * cos(angle)) - (self.y * sin(angle)), (self.x * sin(angle)) + (self.y * cos(angle))
      return self
    end,
    rotateDegrees = function(self, angle)
      return self:rotate(rad(angle))
    end,
    lerp = function(self, v, am)
      self.x = self.x + ((v.x - self.x) * am)
      self.y = self.y + ((v.y - self.y) * am)
      return self
    end,
    lerpedTo = function(self, v, am)
      return self:clone() + ((v - self) * am)
    end,
    angleTo = function(self, v)
      local d = self:dot(v)
      local v1Mag = self:magnitude()
      local v2Mag = v:magnitude()
      local amt = dot / (v1Mag * v2Mag)
      if amt <= -1 then
        return pi
      elseif amt > 1 then
        return 0
      else
        return acos(amt)
      end
    end,
    angleToDegrees = function(self, v)
      return deg(self:angleTo(v))
    end,
    __tostring = function(self)
      return ("(%.3f, %.3f)"):format(self.x, self.y)
    end,
    __add = function(self, v)
      return Vector2(self.x + v.x, self.y + v.y)
    end,
    __sub = function(self, v)
      return Vector2(self.x - v.x, self.y - v.y)
    end,
    __mul = function(self, s)
      if type(self) == Vector2 and type(s) == "number" then
        return Vector2(self.x * s, self.y * s)
      elseif type(self) == "number" and type(s) == Vector2 then
        return Vector2(self * s.x, self * s.y)
      end
    end,
    __div = function(self, s)
      if type(self) == Vector2 and type(s) == "number" then
        return Vector2(self.x / s, self.y / s)
      end
    end,
    __unm = function(self)
      return self * -1
    end,
    __concat = function(self, o)
      return tostring(self) .. tostring(o)
    end,
    __eq = function(self, v)
      return self.x == v.x and self.y == v.y
    end,
    __lt = function(self, v)
      return self:magnitudeSquared() < v:magnitudeSquared()
    end,
    __le = function(self, v)
      return self:magnitudeSquared() <= v:magnitudeSquared()
    end,
    random = function()
      return Vector2.fromAngle(random() * pi * 2)
    end,
    fromAngle = function(angle)
      return Vector2(cos(angle), sin(angle))
    end,
    fromAngleRadians = function(angle)
      return Vector2(cos(angle), sin(angle))
    end,
    fromAngleDegrees = function(angle)
      angle = rad(angle)
      return Vector2(cos(angle), sin(angle))
    end,
    distanceBetween = function(v1, v2)
      return (v2 - v1):magnitude()
    end,
    distanceBetweenSquared = function(v1, v2)
      return (v2 - v1):magnitudeSquared()
    end,
    angleBetween = function(v1, v2)
      return v1:angleTo(v2)
    end,
    angleBetweenDegrees = function(v1, v2)
      return deg(v1:angleTo(v2))
    end,
    zero = function()
      return Vector2(0, 0)
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      if type(x) == "table" then
        self.x = x.x or x[1] or 0
        self.y = x.y or x[2] or 0
      else
        self.x = x
        self.y = y
      end
    end,
    __base = _base_0,
    __name = "Vector2"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Vector2 = _class_0
end
