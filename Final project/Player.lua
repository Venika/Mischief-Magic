local Player = {tag="player"}

function Player:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Player:draw(screenW, screenH)
  self.shape = display.newImage( "Wiz.png")
  self.shape:scale(.1,.1)
  self.shape.pp = self
  self.shape.tag = self.tag; -- “enemy"
	self.shape:setFillColor(1,1,1,1)
 	self.shape.speed = 90
  self.shape.trotation = self.shape.rotation
self.shape.x = display.contentCenterX
self.shape.y = display.contentCenterY
physics.addBody( self.shape, "kinematic", {filter = {categoryBits = 1, maskBits = 12}, shape=  {0,-20, -17.320508, 10, 17.320508, 10}, density=1.0, friction=0, bounce=0} )
end

return Player
