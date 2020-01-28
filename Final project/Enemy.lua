local Enemy = {tag="enemy", HP=1, xPos=0, yPos=0, fR=0, sR=0, bR=0, fT=1000, sT=500, bT	=500};

function Enemy:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Enemy:spawn(pos)
if pos==nil then
 pos={x = 80, y= 80}
end
 self.shape=display.newImage( "Enemy.png" )
 self.shape.x = pos.x
 self.shape.y = pos.y
 self.shape:scale(.03,.03)
 self.shape.pp = self;  -- parent object
 self.shape.tag = self.tag; -- “enemy”
 self.shape:setFillColor (1,1,1,1);
 physics.addBody(self.shape, "dynamic", {filter = {categoryBits=4, maskBits=27}, shape = { 0, -15, -14.2658, -4.6352, -8.81677, 12.13525, 8.81677, 12.13525, 14.2658, -4.6352}});
end



function Enemy:forward (settings)
  if (self.timer == nil) then
      if (settings.player.shape.x~=nil and  self.shape.x~=nil) then
       self.timer = timer.performWithDelay( 250, function()
        local x_dist = self.shape.x - settings.player.shape.x
        local y_dist = self.shape.y - settings.player.shape.y
        local dist = math.sqrt(x_dist^2 + y_dist^2);
        local x_speed = x_dist/dist*30
        local y_speed = y_dist/dist*30
        self.shape:setLinearVelocity(-x_speed, -y_speed)
        local theta = math.atan2(-y_speed, -x_speed)*180/math.pi
        if (theta < 0) then
          theta = theta + 360
        end
    --  self.shape.rotation=90+theta
  end, -1)
  end
end
end

function Enemy:move (settings)
	self:forward(settings);
end

function Enemy:hit()

  self.HP = self.HP - 1;

	if (self.HP == 0) then
		timer.cancel ( self.timer );
    display.remove(self.shape)
		self.shape=nil;
		self = nil;
  --  settings.score = settings.score + 1;
  --  print("Score: " .. settings.score)
	end
end

function Enemy:stop()
  if(self.shape~=nil) then
  timer.cancel( self.timer )
end
  --self.shape:setLinearVelocity(0,0)
end



return Enemy
