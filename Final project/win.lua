-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local storyBtn
local playBtn
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


-- 'onRelease' event listener for playBtn


function scene:create( event )
	local sceneGroup = self.view



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		local startsound = audio.loadSound("menumusic.mp3",{ loops=2 })
		audio.play(startsound);
		-- create a widget button (which will loads level1.lua on release)

	local scale_factor = 1672/screenW
	local gameOver = display.newImage( "Win.png")
	gameOver:translate(screenW/2-20 , -40)
	gameOver.alpha = 0
	gameOver:scale(.2, .2)
	--gameOver:translate(screenW/2 , screenH/3)
	--transition.to( background, {alpha = .7, time = 1500} )
	transition.to( gameOver, {alpha = 1,x = display.contentCenterX, y = screenH/3, time = 1500} )

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = 19



	playBtn = display.newImage( "button_play-now.png")
	--playBtn:translate(screenW/2-20 ,20)
	playBtn:scale(.7,.7)
	playBtn:translate(screenW/2-20 ,20)
	transition.to( playBtn, {alpha = 1,x = display.contentCenterX, y = display.contentCenterY+10, time = 1500} )



	local function onPlayBtnRelease()
		composer.removeScene("win")
		audio.pause(startsound);
		composer.gotoScene( "Level", "fade", 500 )
	end
	playBtn:addEventListener("tap", onPlayBtnRelease)




	sceneGroup:insert(gameOver)
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
end


		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.


end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
