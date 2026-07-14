local Scene = require("scene")

local Push = require("lib/push")
local Splash = require("src/scenes/splash")

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 800

VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 800


function love.load()
    --love.window.setMode(800, 800)
    love.graphics.setDefaultFilter("nearest", "nearest")
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, vsync=true, resizable = true})
    Scene.switch(Splash)


end


function love.resize(w, h)
    Push:resize(w, h)
end

function love.mousepressed( x, y, button, istouch, presses )
    Scene.mousepressed(x, y, button, istouch, presses)
end

function love.keypressed( key, scancode, isrepeat )
    Scene.keypressed(key)
end


function love.update(dt)
    Scene.update(dt)

end


function love.draw()
    Push:start()
    Scene.draw()
    Push:finish()
end