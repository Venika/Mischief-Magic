-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
--local perspective = require("perspective")
local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

		physics.start()
		--physics.pause()
		physics.setGravity( 0, 0 )
		physics.setDrawMode( "normal" )



local settings = {}

local enemy = require "Enemy"
local bolt = require "Bolt"
local player = require "Player"
local portaltemp = require "Portal"
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
--local camera = perspective.createView()




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

		--bg
			local bg = display.newImage( "f3.png", display.contentCenterX, display.contentCenterX)
			bg:scale(1.2,1.45)
			bg:setFillColor(1,1,1,1)
			bg.alpha=.7


		scoretext=display.newText( "Score: ",display.contentCenterX+200, display.contentCenterY-140,"Helvetica",28 )

		local hs=0;


		scoretextupdate=display.newText(hs ,display.contentCenterX+260, display.contentCenterY-140,"Helvetica",28 )



		local enemies = {}
		local attacks = {}

			settings.player = player:new()
			settings.player:draw(screenW, screenH)
			settings.cool = true
			settings.score = 0



			local joy_options = { frames = {{x=0, y=0, height = 164, width = 164}, {x=164,y=0, height=164, width = 0}}}
			local joystick_sheet = graphics.newImageSheet( "Joystick.png", joy_options )
			local joystick_seqdata = {
			  {name="still",frames={1}},
			  {name="moving",frames={2}}
			}

			joystick = display.newSprite( joystick_sheet, joystick_seqdata )
			joystick.xScale = .5
			joystick.yScale = .5
			joystick.x = 114/3;
			joystick.y = display.actualContentHeight-125*1/3;
			joystick.alpha = .9;

			portal = portaltemp:new()
			portal:spawn(settings.player)


			function joyCalc(event)
			    local x_dist = joystick.x - event.x
			    local y_dist = joystick.y - event.y
			    local dist = math.sqrt(x_dist^2 + y_dist^2);
			    local x_speed = x_dist/dist*settings.player.shape.speed
			    local y_speed = y_dist/dist*settings.player.shape.speed
			--    settings.player.x = settings.player.x - (x_speed)
			--    settings.player.y = settings.player.y - (y_speed)

					if (dist > 24) then
			    	settings.player.shape:setLinearVelocity(- x_speed, - y_speed)
					else
						settings.player.shape:setLinearVelocity(-x_speed*dist/24, -y_speed*dist/24)
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
			    settings.player.shape.trotation = 90 + theta
			  end


			function joyhandler(event)
			  if event.phase == "began" then
			    joyCalc(event);
			  end
			  if event.phase == "moved" then
			    joyCalc(event);
			  end
			  if event.phase == "ended" then
			    settings.player.shape:setLinearVelocity(0,0)
			  end
			end

			function boltattackHandler(event)
				if(event.phase=="ended") then
					local startsound = audio.loadSound("shoot.wav")   --ADDED LATER!!!
					audio.play(startsound);
						attacks[#attacks+1] = bolt:new()
						attacks[#attacks]:spawn(settings.player, 8000)
						attacks[#attacks].shape.id = #attacks
					end
			end

			function bigattackHandler(event)
				if (event.phase=="ended") then
						if (settings.cool == true) then
							settings.cool = false
							local startsound = audio.loadSound("BigAt.wav")   --ADDED LATER!!!
							audio.play(startsound);
							aoetimer = timer.performWithDelay( 10, function()
							settings.player.shape.trotation = settings.player.shape.trotation + 5.625
							attacks[#attacks + 1] = bolt:new()
							attacks[#attacks]:spawn(settings.player, 1000)
							attacks[#attacks].shape.id = #attacks	end	, 64)
							cooldown = timer.performWithDelay( 5000, function() settings.cool = true end, 1)
							end
						end
					end

			function bigAttack(iterations, attack, event)
				local secondstage = timer.performWithDelay( 20, function ()
					if (attack~=nil) then
						attack:removeSelf()
						attack = nil
					end
					attack = display.newCircle( settings.player.shape.x, settings.player.shape.y, 20+iterations)
					attack:setFillColor(1,0,0,.3)
					iterations = iterations + 1
					if event.phase~="ended" then
						return bigAttack(iterations, attack, event)
					else
						return attack
					end
				end, 1)
			end





			function spawn_offscreen ()
				local x = math.random(30, 90)
				local x1 = math.random (1, 2)

				local y = math.random(30, 90)
				local y1 = math.random(1,2)

				if (x1==2) then
					x = display.actualContentWidth + x
				else
					x = display.screenOriginX - x
				end

				if (y1==2) then
					y = display.actualContentHeight + y
				else
					y = display.screenOriginY - y
				end


				--tableTest[#tableTest + 1] = {drawT(math.random(-2*xx, xx*4), math.random(-2*yy, yy*4)), 0} end, 20
				enemies[#enemies+1] = enemy:new()
				enemies[#enemies]:spawn({x=x, y=y})
				enemies[#enemies]:move(settings)
				enemies[#enemies].shape.id = #enemies
			end

			function spawn_onscreen ()
				local x = math.random(0, screenW)
				local y = math.random(0, screenH)
				--tableTest[#tableTest + 1] = {drawT(math.random(-2*xx, xx*4), math.random(-2*yy, yy*4)), 0} end, 20
				enemies[#enemies+1] = enemy:new()
				enemies[#enemies]:spawn({x=x, y=y})
				enemies[#enemies]:move(settings.player.shape)
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

				local finalscore=display.newText( "Final Score: "..hs,display.contentCenterX, display.contentCenterY,"Helvetica",28  )
				--finalscore:translate(screenW/2-20 ,20)
				transition.to( finalscore, {alpha = 1,x = display.contentCenterX, y = display.contentCenterY+60, time = 1500} )

				gameOver:translate(screenW/2-20 , -40)
				gameOver.alpha = 0
				gameOver:scale(.2, .2)
				--gameOver:translate(screenW/2 , screenH/3)
				transition.to( background, {alpha = .7, time = 1500} )
				transition.to( gameOver, {alpha = 1,x = display.contentCenterX, y = screenH/4, time = 1500} )

				retryBtn=display.newImage( "button_retry.png")
				retryBtn:translate(screenW/2-20 ,20)
				transition.to( retryBtn, {alpha = 1,x = display.contentCenterX, y = display.contentCenterY+10, time = 1500} )

				local function retry()
					joystick:removeEventListener("touch", joyhandler)
					l1_attack:removeEventListener("touch", boltattackHandler)
					l2_attack:removeEventListener("touch", bigattackHandler)
					timer.cancel( timer2 )
					display.remove(settings.player.shape)
						for i=1,table.getn(enemies) do
							if (enemies[i].shape ~= nil) then
							enemies[i]:stop()
							display.remove(enemies[i].shape)
						end--end if
					end--end for
					--display.remove( player.shape )
					timer.cancel( portal.jumper )
					timer.cancel(portal.rotater)
					--portal.stop()
					display.remove(portal.shape)
					portal.shape = nil
					Runtime:removeEventListener( "collision", onGlobalCollision )
				composer.removeScene( "level3" )
				composer.gotoScene( "Level" )
			end
		  	retryBtn:addEventListener("tap",retry)



				sceneGroup:insert(background)
				sceneGroup:insert(gameOver)
				sceneGroup:insert(retryBtn)
				sceneGroup:insert(finalscore)

		 end

		 function onGlobalCollision( event )
				if ( event.object1.tag=="player" and event.object2.tag=="enemy") then
					joystick:removeEventListener("touch", joyhandler)
					l1_attack:removeEventListener("touch", boltattackHandler)
					l2_attack:removeEventListener("touch", bigattackHandler)
					timer.cancel( timer2 )
					--portal.stop()
					timer.cancel( portal.jumper )
					timer.cancel(portal.rotater)
					--portal.stop()
					display.remove(portal.shape)
					portal.shape = nil
				local startsound = audio.loadSound("game_over.mp3")
				audio.play(startsound);
					display.remove(settings.player.shape)
					for i=1,table.getn(enemies) do
						if (enemies[i].shape ~= nil) then
							enemies[i]:stop()
							display.remove(enemies[i].shape)
						--	enemies[i].shape:removeSelf()
					end --end if
				end--end for
					printGameOver()
				elseif (event.object1.tag=="enemy" and event.object2.tag=="Bolt" ) then

					if(enemies[event.object1.id]~=nil and attacks[event.object2.id]~=nil ) then
						enemies[event.object1.id]:hit()
						attacks[event.object2.id]:hit()
					hs=hs+1
				end--end if

			 elseif (event.object1.tag=="player" and event.object2.tag=="portal" or event.object1.tag=="portal" and event.object2.tag=="player") then
				 if(event.phase=="ended") then

					joystick:removeEventListener("touch", joyhandler)
					l1_attack:removeEventListener("touch", boltattackHandler)
					l2_attack:removeEventListener("touch", bigattackHandler)
					timer.cancel( timer2 )
					display.remove(settings.player.shape)
						for i=1,table.getn(enemies) do
							if (enemies[i].shape ~= nil) then
							enemies[i]:stop()
							display.remove(enemies[i].shape)
						end--end if
					end--end for
					--display.remove( player.shape )
					timer.cancel( portal.jumper )
					timer.cancel(portal.rotater)
					--portal.stop()
					display.remove(portal.shape)
					portal.shape = nil
					Runtime:removeEventListener( "collision", onGlobalCollision )
					composer.removeScene( "level3" )
					composer.gotoScene( "win" )
				end--end begin


			end
			scoretextupdate.text=hs
		end



		--[[  enemy1 = enemy:new()
			enemy1:spawn()
			enemy1:move(settings.player)]]
			timer2 = timer.performWithDelay( 1000, function() spawn_offscreen() end, 100 )


				l1_attack = display.newImage( "2.png", screenW - 3.5*joystick.x, joystick.y, screenW/3, screenW/6 )
				l1_attack :scale(.29,.27)
				--l_attack:setFillColor(0,0,1,.4)
				l1_attack :addEventListener("touch", boltattackHandler)

				l2_attack = display.newImage( "1.png", screenW - 2*joystick.x, joystick.y, screenW/3, screenW/6 )
				l2_attack:scale(.07,.07)
				--l_attack:setFillColor(0,0,1,.4)
				l2_attack:addEventListener("touch", bigattackHandler)



			joystick:addEventListener("touch", joyhandler)
		--	settings.player.collision = collisionHandler
		--	settings.player:addEventListener("collision", settings.player)
			Runtime:addEventListener( "collision", onGlobalCollision )


			sceneGroup:insert(bg)
		sceneGroup:insert(joystick)
		sceneGroup:insert(l1_attack)
		sceneGroup:insert(l2_attack)
		sceneGroup:insert(scoretext)
		sceneGroup:insert(scoretextupdate)


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

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )
		--physics.stop()
	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

		local sceneGroup = self.view

		timer.cancel( portal.jumper )
		timer.cancel(portal.rotater)
		--portal.stop()
		display.remove(portal.shape)
		portal.shape = nil
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
