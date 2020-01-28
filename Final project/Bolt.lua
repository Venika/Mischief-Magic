local Bolt = {tag="Bolt", strength=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

function Bolt:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end


function Bolt:spawn(player, decay)
  if (player.shape~=nil) then
  local x = player.shape.x - math.cos(math.rad(player.shape.trotation)+math.pi/2)*25
  local y = player.shape.y - math.sin(math.rad(player.shape.trotation)+math.pi/2)*25

  self.shape = display.newImageRect( "bolt_spr.png", 30, 30 )
  self.shape.x = x
  self.shape.y = y
  self.shape.pp = self;  -- parent object
  self.shape.tag = self.tag; -- “enemy”

  physics.addBody(self.shape, "dynamic", {filter = {categoryBits = 2, maskBits = 12}, radius = 15 , density=1, friction=0.0, bounce=0.0 } )
  self.shape.isSensor=true;
  self.shape.rotation = (player.shape.trotation)

  self.shape:setLinearVelocity(-math.cos(math.rad(self.shape.rotation)+math.pi/2)*140, -math.sin(math.rad(self.shape.rotation)+math.pi/2)*140)
  self.timer = timer.performWithDelay( decay, function () if(self.shape~=nil) then self:hit() end end, 3)
--  print( "Player x: " .. player.x .. "\nPlayer y: " .. player.y .. "\nPlayer rotation: " .. player.rotation .. "\nAttack x_dir: " .. math.cos(self.shape.rotation)*140 .. "\nAttack y_dir: " .. math.sin(self.shape.rotation)*14``
end
end



function Bolt:hit ()
--  self.shape:setFillColor(0,0,0,0);
  --self.shape:setLinearVelocity(0,0);

  -- die
  display.remove( self.shape )
  self.shape=nil;
  self = nil;
end



return Bolt
