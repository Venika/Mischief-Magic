-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local settings = {}

local enemy = require "Enemy"
local bolt = require "Bolt"
local player = require "Player"
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	local enemies = {}
	local attacks = {}

	physics.start()
	physics.pause()
	physics.setGravity( 0, 0 )
	physics.setDrawMode( "hybrid" )

	settings.player = player:new()
	settings.player:draw(screenW, screenH)

	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .1 )

	local joy_options = { frames = {{x=0, y=0, height = 164, width = 164}, {x=164,y=0, height=164, width = 0}}}
	local joystick_sheet = graphics.newImageSheet( "joystick.png", joy_options )
	local joystick_seqdata = {
	  {name="still",frames={1}},
	  {name="moving",frames={2}}
	}

	joystick = display.newSprite( joystick_sheet, joystick_seqdata )
	joystick.xScale = .7
	joystick.yScale = .7
	joystick.x = 114/2;
	joystick.y = display.actualContentHeight-114*2/3;
	joystick.alpha = .1;


	function joyCalc(event)
	    local x_dist = joystick.x - event.x
	    local y_dist = joystick.y - event.y
	    local dist = math.sqrt(x_dist^2 + y_dist^2);
	    local x_speed = x_dist/dist*settings.player.obj.speed
	    local y_speed = y_dist/dist*settings.player.obj.speed
	--    settings.player.x = settings.player.x - (x_speed)
	--    settings.player.y = settings.player.y - (y_speed)

			if (dist > 24) then
	    	settings.player.obj:setLinearVelocity(- x_speed, - y_speed)
			else
				settings.player.obj:setLinearVelocity(-x_speed*dist/24, -y_speed*dist/24)
			end

	    local theta = math.atan2(-y_dist, -x_dist)*180/math.pi
	    if (theta < -90) then
	      theta = theta + 360
	    end
			while (theta > 270) do
				theta = theta - 360
			end
	--[[    joystick:setSequence("moving");
	    joystick:play();
	    joystick.rotation= 90 + theta]]
	    settings.player.obj.rotation = 90 + theta
	  end


	function joyhandler(event)
	  if event.phase == "began" then
	    joyCalc(event);
	  end
	  if event.phase == "moved" then
	    joyCalc(event);
	  end
	  if event.phase == "ended" then
	    settings.player.obj:setLinearVelocity(0,0)
	  end
	end

	function bigAttack(iterations, attack, event)
		local secondstage = timer.performWithDelay( 20, function ()
			if (attack~=nil) then
				attack:removeSelf()
				attack = nil
			end
			attack = display.newCircle( settings.player.obj.x, settings.player.obj.y, 20+iterations)
			attack:setFillColor(1,0,0,.3)
			iterations = iterations + 1
			if event.phase~="ended" then
				return bigAttack(iterations, attack, event)
			else
				return attack
			end
		end, 1)
	end


	function attackHandler(event)
		if (event.x < l_attack.x) then
			if(event.phase=="ended") then
				attacks[#attacks+1] = bolt:new()
				attacks[#attacks]:spawn(settings.player)
				attacks[#attacks].shape.id = #attacks
			end
		else
			local attack = nil
			local triggered = false
			local iterations = 0
			local firsttimer = timer.performWithDelay( 2000, function () attack=bigAttack(iterations, attack, event) triggered = true end, 1)
			timer.pause( firsttimer )
			if (event.phase=="began") then
				timer.resume( firsttimer )
			end
			if (event.phase=="ended") then
				timer.pause( firsttimer )
				timer.cancel( firsttimer )
				if (triggered == true) then
					attack:setFillColor(1,0,0,1)
					physics.addBody( attack, {radius = attack.radius, filter = {categoryBits=16, maskBits = 4}})
					local timer3 = timer.performWithDelay(1000, function() attack:setFillColor(0,0,0,0) attack:removeSelf() end, 1)
				end
			end
		end
 	end

	function spawn_offscreen ()
		local x = math.random(-2*screenW, 3*screenW)
		while (x > 0 and x < screenW) do
			x = math.random(-2*screenW, 3*screenW)
		end
		local y = math.random(-2*screenH, 3*screenH)
		while (y > 0 and y < screenW) do
			y = math.random(-2*screenW, 3*screenW)
		end

		--tableTest[#tableTest + 1] = {drawT(math.random(-2*xx, xx*4), math.random(-2*yy, yy*4)), 0} end, 20
		enemies[#enemies+1] = enemy:new()
		enemies[#enemies]:spawn({x=x, y=y})
		enemies[#enemies]:move(settings.player.obj)
		enemies[#enemies].shape.id = #enemies
	end

	function spawn_onscreen ()
		local x = math.random(0, screenW)
		local y = math.random(0, screenH)
		--tableTest[#tableTest + 1] = {drawT(math.random(-2*xx, xx*4), math.random(-2*yy, yy*4)), 0} end, 20
		enemies[#enemies+1] = enemy:new()
		enemies[#enemies]:spawn({x=x, y=y})
		enemies[#enemies]:move(settings.player.obj)
		enemies[#enemies].shape.id = #enemies
	end

	function printGameOver()
		local scale_factor = 1672/screenW
		local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
		local gameOver = display.newImage( "Game_Over.png")
		background.anchorX = 0
		background.anchorY = 0
		background.alpha = 0
		background:setFillColor(0,0,0)

		gameOver:translate(screenW/2-20 , -40)
		gameOver.alpha = 0
		gameOver:scale(.2, .2)
		--gameOver:translate(screenW/2 , screenH/3)
		transition.to( background, {alpha = .7, time = 3500} )
		transition.to( gameOver, {alpha = 1,x = screenW/2-20, y = screenH/3, time = 3500} )
 end
--[[	function collisionHandler(self, event)
  	if (event.other.tag=="enemy") then
			joystick:removeEventListener("touch", joyhandler)
					settings.player:setLinearVelocity(0,0)
			for i=1,table.getn(enemies) do
				enemies[i]:stop()
			end
		end
	end]]

 function onGlobalCollision( event )
    if ( event.object1.tag=="player" or event.object2.tag=="player") then
			joystick:removeEventListener("touch", joyhandler)
			l_attack:removeEventListener("touch", attackHandler)
			timer.cancel( timer2 )
			settings.player.obj:setLinearVelocity(0,0)
			for i=1,table.getn(enemies) do
				if (enemies[i].shape ~= nil) then
					enemies[i]:stop()
				end
			end
			printGameOver()
		elseif (event.object1.tag=="enemy") then
--			print("Strength: " .. event.object2.strength .. "\n")
			--event.object1:hit(event.object2.strength)
			enemies[event.object1.id]:hit(attacks[event.object2.id].strength)
			attacks[event.object2.id]:hit()
    elseif ( event.object1.tag=="Bolt") then
			enemies[event.object2.id]:hit(attacks[event.object1.id].strength)
			attacks[event.object1.id]:hit()
    end
	end

--[[  enemy1 = enemy:new()
	enemy1:spawn()
	enemy1:move(settings.player)]]
	timer2 = timer.performWithDelay( 5000, function() spawn_offscreen() end, 90 )

	l_attack = display.newRect( screenW - 2*joystick.x, joystick.y, screenW/3, screenW/6 )
	l_attack:setFillColor(0,0,1,.4)
	l_attack:addEventListener("touch", attackHandler)

	joystick:addEventListener("touch", joyhandler)
--	settings.player.collision = collisionHandler
--	settings.player:addEventListener("collision", settings.player)
	Runtime:addEventListener( "collision", onGlobalCollision )

	-- make a crate (off-screen), position it, and rotate slightly
	-- add physics to the crate
	-- create a grass object and add physics (with custom shape)


end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
