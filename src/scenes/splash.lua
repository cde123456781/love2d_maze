local Maze = require("src/scenes/maze")
local Scene = require("scene")
local Push = require("lib/push")

local Splash = {
    logo = love.graphics.newImage("assets/images/logo.png"),
    timer = 0,
    fade_in_time = 2,
    fade_out_time = 6,
    fade_out = false,
    opacity = 1
}

function Splash:enter()
    self.timer = 0
    self.opacity = 1
    self.button_pressed = false
    self.button_pressed_timer = 0
    self.fade_out = false
end

function Splash:keypressed(key)
    self.fade_out = true

end

function Splash:leave()
    self.timer = 0
    self.opacity = 1
    self.button_pressed = false
    self.button_pressed_timer = 0
    self.fade_out = false
    love.graphics.setColor(0, 0, 0)
end

function Splash:update(dt)
    self.timer = self.timer + dt
    if self.fade_out or self.timer > self.fade_out_time then
        self.opacity = math.min(self.opacity + 1/self.fade_in_time * dt, 1)
        if self.opacity == 1 then
            Scene.switch(Maze)
        end
        
    else 
        self.opacity = math.max(self.opacity - 1/self.fade_in_time * dt, 0)
    end
end


function Splash:draw()
    local window_w = Push:getWidth()
    local window_h = Push:getHeight()
    local x = (window_w - self.logo:getWidth())/2
    local y = (window_h - self.logo:getHeight())/2
    local oldFont = love.graphics.getFont()
    local font = love.graphics.newFont("assets/fonts/monogram.ttf", 100)
    
    love.graphics.clear(255/255, 198/255, 173/255)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.logo, x, y)
    love.graphics.setColor(174/255, 200/255, 1)
    
    love.graphics.setFont(font)
    love.graphics.print("Made with", (window_w - font:getWidth("Made with"))/2, window_h * 0.1)
    love.graphics.setFont(oldFont)

    love.graphics.setColor(0, 0, 0, self.opacity)
    love.graphics.rectangle("fill", 0, 0, window_w, window_h)
    
    
    


end

return Splash