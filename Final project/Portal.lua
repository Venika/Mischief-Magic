local Portal = {tag="portal", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

function Portal:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Portal:spawn(player)
 self.shape=display.newImageRect( "Portal.png", 78, 78 )
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “enemy”

 physics.addBody(self.shape, "dynamic", {filter = {categoryBits=4, maskBits=27}, radius = 39});
 self.shape.isSensor = true
 self.rotater = timer.performWithDelay( 25, function() self.shape.rotation = self.shape.rotation + 1 end, -1 )

 self:unjump(player)
end



function Portal:jump(player)
  local y = math.random(display.screenOriginY+40, display.actualContentHeight-40)
  local x = math.random(display.screenOriginX+40, display.actualContentWidth-40)
  if(player.shape.x~=nil) then
  while (math.abs(x-player.shape.x) < 42) do
    x = math.random(display.screenOriginX+40, display.actualContentWidth-40)
  end
  while (math.abs(y-player.shape.y) < 42) do
    y = math.random(display.screenOriginY+40, display.actualContentHeight-40)
  end
end
  self.shape.x = x
  self.shape.y = y
  self.jumper = timer.performWithDelay( 6000, function() self:unjump(player) end, 1)

end

function Portal:unjump(player)
  self.shape.x = display.contentCenterX
  self.shape.y = display.actualContentHeight*-4
  self.jumper = timer.performWithDelay( 30000, function() self:jump(player) end, 1)
end

function Portal:stop()
  timer.cancel( self.jumper )
  timer.cancel(self.rotater)
  display.remove(self.shape)
  self.shape = nil
  self = nil

end

return Portal
