local Joystick = {}

function Joystick:new (o)    --constructor
  o = o or {};
  setmetatable(o, self);
  self.__index = self;
  return o;
end

self.options = { frames = {{x=0, y=0, height = 164, width = 164}, {x=164,y=0, height=164, width = 0}}}
self.joystick_sheet = graphics.newImageSheet( "joystick.png", self.options )
self.joystick_seqdata = {
  {name="still",frames={1}},
  {name="moving",frames={2}}
}

function Joystick:draw()
    self.obj = display.newSprite( self.joystick_sheet, self.joystick_seqdata )
    self.obj.anchorX = .5
    self.obj.anchorY = .5
    self.obj.xScale = .7
    self.obj.yScale = .7
    self.obj.x = 114/2;
    self.obj.y = display.actualContentHeight-114*2/3;
    self.obj.alpha = .1;
end
