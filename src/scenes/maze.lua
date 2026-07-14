local maze_size = 20
local maze_square_size = 25
local button_width = 100
local button_height = 40
local Push = require("lib/push")

local Maze = {
    maze = {}
}



function Maze:enter()
    self.maze = {}
    self.click_sound = love.audio.newSource("assets/audio/click.wav", "static")
    self.button_select_sound = love.audio.newSource("assets/audio/blipSelect.wav", "static")
    self.button_selected = "Wall"
    self.window_w = Push:getWidth()
    self.window_h = Push:getHeight()
    self.col_start = (self.window_w - maze_size * maze_square_size)/2
    self.col_end = self.col_start + maze_size * maze_square_size
    self.row_start = maze_square_size
    self.row_end = maze_square_size + maze_size * maze_square_size

    self.start_position = nil
    self.goal_position = nil

    self.clear_maze = false


    local button_x = self.col_end + maze_square_size
    local font = love.graphics.getFont()

    self.buttons = {
        {
            x = button_x,
            y = maze_square_size,
            font_x = button_x + (button_width - font:getWidth("Draw Wall"))/2,
            font_y = maze_square_size + (button_height - font:getHeight())/2,
            label = "Draw Wall",
            hover = false,
            tool = "Wall"
        },
        {
            x = button_x,
            y = maze_square_size * 3,
            font_x = button_x + (button_width - font:getWidth("Draw Start"))/2,
            font_y = maze_square_size * 3 + (button_height - font:getHeight())/2,
            label = "Draw Start",
            hover = false,
            tool = "Start"
        },

        {
            x = button_x,
            y = maze_square_size * 5,
            font_x = button_x + (button_width - font:getWidth("Draw Goal"))/2,
            font_y = maze_square_size * 5 + (button_height - font:getHeight())/2,
            label = "Draw Goal",
            hover = false,
            tool = "Goal"
        },

        {
            x = button_x,
            y = maze_square_size * 7,
            font_x = button_x + (button_width - font:getWidth("Eraser Tool"))/2,
            font_y = maze_square_size * 7 + (button_height - font:getHeight())/2,
            label = "Eraser Tool",
            hover = false,
            tool = "Eraser"
        },

        {
            x = button_x,
            y = maze_square_size * 9,
            font_x = button_x + (button_width - font:getWidth("Clear Maze"))/2,
            font_y = maze_square_size * 9 + (button_height - font:getHeight())/2,
            label = "Clear Maze",
            hover = false,
            tool = "Clear"
        },



    }

    

    self.cursor = love.mouse.getSystemCursor("hand")




    self:generate_maze()
end

function Maze:generate_maze()
    self.maze = {}
    self.start_position = nil
    self.goal_position = nil
    self.clear_maze = false

    for i=1, maze_size, 1 do
        local row = {}
        for j=1, maze_size, 1 do
            table.insert(row, "")
        end
        table.insert(self.maze, row)
    end

end


function Maze:mousepressed()
    if love.mouse.isDown(1) then
        local x, y = Push:toGame(love.mouse.getPosition())
        for i, k in ipairs(self.buttons) do
            if x > k.x and x < k.x + button_width and y > k.y and y < k.y + button_height then
                if (k.tool ~= "Clear") then
                    self.button_selected = k.tool
                else 
                    self.clear_maze = true
                end
                love.audio.play(self.button_select_sound)
                
            end
        end

        if x > self.col_start and x < self.col_end and y > self.row_start and y < self.row_end then
            local col_selected = math.floor((x - self.col_start) / maze_square_size) + 1
            local row_selected = math.floor((y - self.row_start) / maze_square_size) + 1
            if col_selected <= maze_size and row_selected <= maze_size then
                if self.button_selected == "Start" then
                    if self.start_position ~= nil then
                        self.maze[self.start_position.row][self.start_position.col] = ""
                    end
                    self.maze[row_selected][col_selected] = "Start"
                    self.start_position = {row = row_selected, col = col_selected}
                    self.click_sound:setPitch(love.math.random(80, 110) / 100)
                    love.audio.play(self.click_sound)
                elseif self.button_selected == "Goal" then
                    if self.goal_position ~= nil then
                        self.maze[self.goal_position.row][self.goal_position.col] = ""
                    end
                    self.maze[row_selected][col_selected] = "Goal"
                    self.goal_position = {row = row_selected, col = col_selected}
                    self.click_sound:setPitch(love.math.random(80, 110) / 100)
                    love.audio.play(self.click_sound)
                end
            end
        end




    end
    


    

end

function Maze:handle_mouse_hold()
    local x, y = Push:toGame(love.mouse.getPosition())
    if x == nil or y == nil then
        return
    end
    if x > self.col_start and x < self.col_end and y > self.row_start and y < self.row_end then
        local col_selected = math.floor((x - self.col_start) / maze_square_size) + 1
        local row_selected = math.floor((y - self.row_start) / maze_square_size) + 1
        if col_selected <= maze_size and row_selected <= maze_size then
            if self.button_selected == "Wall" then
                if self.start_position and self.start_position.row == row_selected and self.start_position.col == col_selected then
                    self.start_position = nil
                end
                if self.goal_position and self.goal_position.row == row_selected and self.goal_position.col == col_selected then
                    self.goal_position = nil
                end
                self.maze[row_selected][col_selected] = "Wall"
                self.click_sound:setPitch(love.math.random(80, 110) / 100)
                love.audio.play(self.click_sound)
            elseif self.button_selected == "Eraser" then
                if self.start_position and self.start_position.row == row_selected and self.start_position.col == col_selected then
                    self.start_position = nil
                end
                if self.goal_position and self.goal_position.row == row_selected and self.goal_position.col == col_selected then
                    self.goal_position = nil
                end
                self.maze[row_selected][col_selected] = ""
                self.click_sound:setPitch(love.math.random(80, 110) / 100)
                love.audio.play(self.click_sound)
            end
        end
    end
end

function Maze:button_hover()
    local x, y = Push:toGame(love.mouse.getPosition())
    if x == nil or y == nil then
        return
    end

    local is_hovering = false
    for i, k in ipairs(self.buttons) do
        if x > k.x and x < k.x + button_width and y > k.y and y < k.y + button_height then
            self.buttons[i].hover = true
            love.mouse.setCursor(self.cursor)
            is_hovering = true
        else
            self.buttons[i].hover = false
        end
    end

    if not is_hovering then
        love.mouse.setCursor()
    end

end

function Maze:update(dt)
    if self.clear_maze then
        self:generate_maze()
    end
    if love.mouse.isDown(1) then
        Maze:handle_mouse_hold()
    end

    self:button_hover()
    
end


function Maze:draw()
   
    
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0, 0, 0)
    for row, k in ipairs(self.maze) do
        for col, l in ipairs(k) do
            love.graphics.rectangle("line", self.col_start + (col - 1) * maze_square_size, row * maze_square_size, maze_square_size, maze_square_size)
            if (self.maze[row][col] == "Wall") then
                love.graphics.rectangle("fill", self.col_start + (col - 1) * maze_square_size + 1, row * maze_square_size + 1, maze_square_size - 2, maze_square_size - 2)
            elseif (self.maze[row][col] == "Start") then
                love.graphics.setColor(0.2, 0.8, 0.2)
                love.graphics.rectangle("fill", self.col_start + (col - 1) * maze_square_size + 1, row * maze_square_size + 1, maze_square_size - 2, maze_square_size - 2)
                love.graphics.setColor(0, 0, 0) 
            elseif (self.maze[row][col] == "Goal") then
                love.graphics.setColor(0.9, 0.2, 0.2)
                love.graphics.rectangle("fill", self.col_start + (col - 1) * maze_square_size + 1, row * maze_square_size + 1, maze_square_size - 2, maze_square_size - 2)
                love.graphics.setColor(0, 0, 0) 
            end
            
        end 
    end

    Maze:draw_buttons()


end


function Maze:draw_buttons() 

    for i, k in ipairs(self.buttons) do
        love.graphics.rectangle("line", k.x, k.y, button_width, button_height)
        if k.hover then
            love.graphics.setColor(144/255,213/255,255/255)
            love.graphics.rectangle("fill", k.x + 1, k.y + 1, button_width - 2, button_height - 2)
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.print(k.label, k.font_x, k.font_y)
    end

    local font = love.graphics.getFont()
    local tool_selected_display = {
        x = self.col_end + maze_square_size + (button_width - font:getWidth("Current Tool: "..self.button_selected))/2,
        y = maze_square_size * 11 + (button_height - font:getHeight())/2,
        label = "Current Tool: "..self.button_selected
    }
    love.graphics.print(tool_selected_display.label, tool_selected_display.x, tool_selected_display.y)
    
end

return Maze