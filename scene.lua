local Scene = {
    current = nil
}

function Scene.switch(newScene) 
    if Scene.current ~= nil and Scene.current.leave ~= nil then
        Scene.current:leave()
    end

    Scene.current = newScene
    if Scene.current ~= nil and Scene.current.enter ~= nil then
        Scene.current:enter()
    end

end


function Scene.update(dt)
    if Scene.current ~= nil and Scene.current.update ~= nil then
        Scene.current:update(dt)
    end
end


function Scene.draw()
    if Scene.current and Scene.current.draw then
        Scene.current:draw()
    end

end

function Scene.keypressed(key) 
    if Scene.current and Scene.current.keypressed then
        Scene.current:keypressed(key)
    end

end


function Scene.mousepressed(x, y, button, istouch, presses)
    if Scene.current and Scene.current.mousepressed then
        Scene.current:mousepressed(x, y, button, istouch, presses)
    end
end


return Scene