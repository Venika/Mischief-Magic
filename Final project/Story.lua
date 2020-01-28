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
local textObject
-- forward declarations and other locals
local backBtn
local scrollView
-- 'onRelease' event listener for backBtn
local scrollListener={}

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










	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
--sceneGroup:insert(textObject)

	--

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

				-- ScrollView listener
				function scrollListener( event )

				    local phase = event.phase

				    -- If the event a scroll limit is reached...
				    if ( event.limitReached ) then
				        if ( event.direction == "up" ) then backBtn.isVisible=true
				        elseif ( event.direction == "down" ) then print( "Reached top limit" )
				        elseif ( event.direction == "left" ) then print( "Reached right limit" )
				        elseif ( event.direction == "right" ) then print( "Reached left limit" )
				        end
				    end

				    return true
				end

				-- Create the widget
				 scrollView = widget.newScrollView
				    {
				        y=display.contentCenterY+50,
				        x=display.contentCenterX,
				        width = display.contentWidth-20,
				        height = display.contentHeight,
								scrollWidth=100,
								scrollHeight=800,
								bottomPadding=100,
							--	isBounceEnabled=false,
								hideBackground=true,
				        horizontalScrollDisabled=true,
								verticalScrollDisabled=false,
				        listener = scrollListener,
				    }


				-- Create a image and insert it into the scroll view
				local textStory= "Long ago, the four nations lived together in harmony. Then, everything changed when all the nations attacked the Fire Kingdom. You are a powerful wizard of the Fire nation who is in search of his magic fire taken away by the kingdoms. Without that fire, you are weak and powerless. The fire is hidden in one of the 3 kingdoms. You must travel to each one of them and search for it or else you will lose all your powers."
					local textStory1=" You will have to fight enemies that are sent to stop you from your mission. Since you are weakened by the loss of fire, any time enemy touches you, you die. Since you have a little bit of power left, you can use two types of attacks- fire bolt and fire sphere. Since fire sphere takes a lot of your energy, you are unable to use it again and again."
					local textStory2="You need to rest a bit for it to recharge. Your aim is to find the portal to the next world and search for your ‘Fire’. The fate of Fire Nation rests on your shoulders. Good Luck! "

			textObject=display.newText( textStory..textStory1..textStory2.."          ",0,0,250,0, "Helvetica",16 )

			 textObject:setTextColor(1,1,1)
			  textObject.x=display.contentCenterX-15
				textObject.y=display.contentCenterY+120
				scrollView:insert( textObject)



			-- create a widget button (which will loads level1.lua on release)
			backBtn = display.newImage( "button_back.png")
			backBtn.x = display.contentCenterX
			backBtn.y = display.contentHeight-15
			backBtn:scale(.7,.7)
			backBtn.isVisible=false

			local function back()
				audio.pause(startsound);
				display.remove(textObject)
				textObject=nil
				display.remove(scrollView)
				scrollView=nil
		  	composer.gotoScene( "menu", "fade",500 )
			end
			backBtn:addEventListener("tap", back)




sceneGroup:insert( backBtn )


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
