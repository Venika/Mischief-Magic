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
local lev2Btn
local lev1Btn



-- 'onRelease' event listener for lev1Btn


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.

	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x =  display.screenOriginX+140
	background.y =  display.screenOriginY+20
	background:scale(.5,1)


	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = 19

	-- create a widget button (which will loads level1.lua on release)
	lev1Btn = display.newImage( "lev1.png")
	lev1Btn.x = display.contentCenterX
	lev1Btn.y = display.contentHeight - 125
	lev1Btn:scale(1,.7)

	local function onlev1BtnRelease()
			-- go to level1.lua scene
		audio.pause(startsound);
		composer.gotoScene( "level1", "fade", 500 )
	end
	lev1Btn:addEventListener("tap", onlev1BtnRelease)

	lev2Btn = display.newImage( "lev2.png")
	lev2Btn.x = display.contentCenterX
	lev2Btn.y = display.contentHeight - 80
	lev2Btn:scale(1,.7)

	local function onlev2BtnRelease()
			-- go to level1.lua scene
		audio.pause(startsound);
		composer.gotoScene( "level2", "fade", 500 )
	end
	lev2Btn:addEventListener("tap", onlev2BtnRelease)


	lev3Btn = display.newImage( "lev3.png")
	lev3Btn.x = display.contentCenterX
	lev3Btn.y = display.contentHeight - 35
	lev3Btn:scale(1,.7)

	local function onlev3BtnRelease()
			-- go to level1.lua scene
		audio.pause(startsound);
		composer.gotoScene( "level3", "fade", 500 )
	end
	lev3Btn:addEventListener("tap", onlev3BtnRelease)


	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( lev2Btn )
	sceneGroup:insert( lev1Btn )
	sceneGroup:insert( lev3Btn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		local startsound = audio.loadSound("menumusic.mp3",{ loops=2 })
		audio.play(startsound);
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
