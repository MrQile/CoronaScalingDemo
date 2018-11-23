-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- This demo uses nothing but static Images and no in-engine visual effects. Do keep in mind this is presented in landscape mode and not portrait.
-- If developing for portrait mode, create images of resolution 360px width and 694px height.
-- And For landscape 694px width and 360px height which we use in this demo project.
-- We use a set of five images whose resolution range from 694*360, 570*360, 480*320, To see how much of blackbox area is screen across devices.
-- We also use set of five ui Images and use display.safe* APIs to position the ui elements is safe regions.

-- Display group for convenience
local backGroup = display.newGroup()

--[[
 If in doubt about the usage of screenOriginX, read this article 
	by Rob Miracle :- https://coronalabs.com/blog/2018/08/08/understanding-content-scaling-in-corona/
]]

-- Top edge of the screen
local topY = display.screenOriginY
print("topEdge :" .. topY)

-- Right edge of the screen
local rightX = display.contentWidth - display.screenOriginX -- display.screenOriginX is a negative value, hence we are actually adding(negative * negative = positive) to the contentWidth.
print("rightEdge :" .. rightX)

-- Botton edge of the screen
local bottomY = display.contentHeight - display.screenOriginY
print("bottomEdge :" .. bottomY)

-- Left edge of the screen
local leftX = display.screenOriginX
print("leftEdge :" .. leftX)

-- BACKGROUND

local background = {}
background[1] = display.newImageRect(backGroup, "sliderImages/1st Static image 694_360.png", 694, 360)
background[1].x = display.contentCenterX
background[1].y = display.contentCenterY
background[1].xMax = background[1].contentBounds.xMax
background[1].enterFrame = sideScroller
print("the right edge of background[1] image:" .. background[1].xMax)

background[2] = display.newImageRect(backGroup, "sliderImages/2nd Static image 694_360.png", 694, 360)
background[2].x = background[1].xMax + display.actualContentWidth * 0.5
background[2].y = display.contentCenterY
background[2].enterFrame = sideScroller

background[3] = display.newImageRect(backGroup, "sliderImages/3rd Static image 694_360.png", 694, 360)
background[3].x = background[1].xMax + display.actualContentWidth * 0.5
background[3].y = display.contentCenterY
background[3].enterFrame = sideScroller

-- to see the effects of using 570*360 resolution images across all devices
background[4] = display.newImageRect(backGroup, "sliderImages/4th Static image 570_360.png", 570, 360)
background[4].x = background[1].xMax + display.actualContentWidth * 0.5
background[4].y = display.contentCenterY
background[4].enterFrame = sideScroller

-- to see the effects of using 480*320 resolution images across all devices
background[5] = display.newImageRect(backGroup, "sliderImages/5th static image 480_320.png", 480, 360)
background[5].x = background[1].xMax + display.actualContentWidth * 0.5
background[5].y = display.contentCenterY
background[5].enterFrame = sideScroller

local scrollNum = 1 	-- Used to indicate which background image to be scrolled. Explained la



-- SIDE SCROLLER OF BACKGROUND IMAGES

--[[ 
	How this works :-
	All the background images are stacked on the region, past the right edge of screen ,which is not visible.
	When loaded the first image is displayed, while the remaining 4 are stacked on the right.
	Using the enterframe event the x value of the first image is reduced so as to give the illusion of it moving left.
	Once it moves past a certain value in the x-axis. It is reset and stacked with the images on the right.
	Here two images are moved towards the left at the same time, so it seems as though they are connected.
	The use of scrollNum is used to indicate which image should be moved now.
	1 for the first image, 2 for the second, 3 for the third and so on.
	Once the scrollNum value is greater than 5, it is reset to value 1 so that the first image starts scrolling left again.

]]
local function sideScroller(event)
	if (background[scrollNum].x < -453) then -- the value of x when it is not visible(exits the screen) anymore while scrolling left.
		background[scrollNum].x = background[1].xMax + display.actualContentWidth * 0.5
		scrollNum = scrollNum + 1
	end
	if scrollNum > 5 then
		scrollNum = 1
	end
		background[scrollNum].x = background[scrollNum].x - 1
	if scrollNum == 5 then	-- if the 5th image is being scrolled, make sure the 1st image starts moving behind it. This is because we dont have a sixth image.
		background[1].x = background[1].x - 1
	else 					-- Otherwise move the next image. If 2nd is image is being scrolled, 2+1 = 3 . So move the 3rd image behind the 2nd image. 
		background[scrollNum+1].x = background[scrollNum+1].x - 1
	end
end

Runtime:addEventListener("enterFrame", sideScroller)




-- To Mark the content area across all devices. CLICK ON THE GRAY CIRCLE TO VIEW

local lineGroup = display.newGroup()
lineGroup.isVisible = false
local lines = {}
lines[1] = display.newLine(lineGroup, 0,0, 0,320) -- left edge of content area
lines[1].strokeWidth = 2
lines[2] = display.newLine(lineGroup, 480,0 , 480,320) -- right edge of content area
lines[2].strokeWidth = 2
lines[3] = display.newLine(lineGroup, rightX-2,topY , rightX-2,bottomY) -- right edge of screen. 2 is subtracted just to make the line visible on screen
lines[3].strokeWidth = 2
lines[3]:setStrokeColor(0,0,1)
lines[4] = display.newLine(lineGroup, leftX+2,topY , leftX+2,bottomY) -- left edge of screen. 2 is added for the same reason above.
lines[4].strokeWidth = 2
lines[4]:setStrokeColor(0,0,1)
--[[ 
	Again considering the landscape orientation of the demo[change View>ViewAs to iphoneX skin].
	We can clear see that the 0,0 is not the top-left corner of the screen and 480,320 is not the bottom-right corner of the screen.
	Hence the values of screenOriginX is negative indicating the the left edge of the screen is equal to the value of screenOriginX.
	Since 320 is the bottom edge of the screen, the screenOriginY value is 0.
	Note that in portrait mode things are flipped.
]]

local function contentArea(event)

	if (event.phase == "began") then
		lineGroup.isVisible = true
	elseif (event.phase == "ended") then
		lineGroup.isVisible = false
	end
	return true
end

local contentAreaCircle = display.newCircle(display.contentCenterX - 30, display.contentCenterY, 15)
contentAreaCircle:addEventListener("touch", contentArea)
contentAreaCircle:setFillColor(0.5,0.5,0.5)
contentAreaCircle:setStrokeColor(1,0,0)
contentAreaCircle.strokeWidth = 3


-- UI ELEMENTS

-- For reference
print( "safeScreenOriginX : " .. display.safeScreenOriginX)
print( "safeScreenOriginY : " .. display.safeScreenOriginY)
print( "safeActualContentWidth : " .. display.safeActualContentWidth)
print( "safeActualContentHeight : " .. display.safeActualContentHeight)


local uiGroup = display.newGroup()

local uiElements = {}
uiElements[1] = display.newImageRect(uiGroup, "UIelements/UI 1.png", 96, 32) -- top left safe region
uiElements[1].x = display.safeScreenOriginX + uiElements[1].width/2
uiElements[1].y = display.safeScreenOriginY + uiElements[1].height/2

uiElements[2] = display.newImageRect(uiGroup, "UIelements/UI 2.png", 96, 32) -- bottom left safe region
uiElements[2].x = display.safeScreenOriginX + uiElements[2].width/2
uiElements[2].y = display.safeActualContentHeight - uiElements[1].height/2 + display.safeScreenOriginY

uiElements[3] = display.newImageRect(uiGroup, "UIelements/UI 3.png", 96, 32) -- top right safe region
uiElements[3].x = display.safeActualContentWidth + display.safeScreenOriginX - uiElements[3].width/2 -- Always know they display.safeScreenOriginX is a negative value, hence we are actually subtracting.
uiElements[3].y = display.safeScreenOriginY + uiElements[3].height/2

uiElements[4] = display.newImageRect(uiGroup, "UIelements/UI 4.png", 96, 32) -- bottom right safe region
uiElements[4].x = display.safeActualContentWidth + display.safeScreenOriginX - uiElements[3].width/2
uiElements[4].y = display.safeActualContentHeight - uiElements[1].height/2 + display.safeScreenOriginY

uiElements[5] = display.newImageRect(uiGroup, "UIelements/UI 5.png", 96, 32) -- bottom center safe region
uiElements[5].x = display.contentCenterX
uiElements[5].y = display.safeActualContentHeight - uiElements[1].height/2 + display.safeScreenOriginY

-- Marking the safe regions. CLICK ON RED CIRCLE TO VIEW

local redLinesGroup = display.newGroup()
redLinesGroup.isVisible = false
local redLines = {}
redLinesGroup:toFront()

local leftSafeX = display.safeScreenOriginX
local topSafeY = display.safeScreenOriginY
local rightSafeX = display.safeActualContentWidth + display.safeScreenOriginX
local bottomSafeY = display.safeActualContentHeight

redLines[1] = display.newLine(redLinesGroup, leftSafeX,topSafeY, leftSafeX,bottomSafeY)
redLines[1].strokeWidth = 5
redLines[1]:setStrokeColor(1,0,0)

redLines[2] = display.newLine(redLinesGroup, rightSafeX,topSafeY, rightSafeX,bottomSafeY)
redLines[2].strokeWidth = 5
redLines[2]:setStrokeColor(1,0,0)


local function safeArea(event)

	if (event.phase == "began") then
		redLinesGroup.isVisible = true
	elseif (event.phase == "ended") then
		redLinesGroup.isVisible = false
	end
	return true
end

local safeAreaCircle = display.newCircle(display.contentCenterX + 30, display.contentCenterY, 15)
safeAreaCircle:addEventListener("touch", safeArea)
safeAreaCircle:setFillColor(1,0,0)
safeAreaCircle:setStrokeColor(0.5,0.5,0.5)
safeAreaCircle.strokeWidth = 3



