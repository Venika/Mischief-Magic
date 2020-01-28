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



-- 'onRelease' event listener for playBtn


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
	playBtn = display.newImage( "button_play-now.png")
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125
	playBtn:scale(.7,.7)

	local function onPlayBtnRelease()
			-- go to level1.lua scene
		audio.pause(startsound);
		composer.gotoScene( "Level", "fade", 500 )
	end
	playBtn:addEventListener("tap", onPlayBtnRelease)

	storyBtn = display.newImage( "button_story.png")
	storyBtn.x = display.contentCenterX
	storyBtn.y = display.contentHeight - 80
	storyBtn:scale(1,.7)

	local function onstoryBtnRelease()
			-- go to level1.lua scene

		composer.gotoScene( "Story", "fade", 00 )
	end
	storyBtn:addEventListener("tap", onstoryBtnRelease)


	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( storyBtn )
	sceneGroup:insert( playBtn )
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
