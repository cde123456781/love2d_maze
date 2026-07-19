local maze_size = 20
local maze_square_size = 25
local button_width = 100
local button_height = 40
local Push = require("lib/push")
local Bfs = require("src/systems/algorithms/bfs")
local Djikstra = require("src/systems/algorithms/djikstra")
local Greedy = require("src/systems/algorithms/greedy")
local AStar = require("src/systems/algorithms/aStar")
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
    self.mode = "Drawing"

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



    local algorithm_button_y = maze_size * (maze_square_size + 3)


    self.algorithm_buttons = {
        {
            y = algorithm_button_y,
            font_y = algorithm_button_y + (button_height - font:getHeight())/2,
            label = "BFS",
            hover = false,

        },
        {

            y = algorithm_button_y,
            font_y = algorithm_button_y + (button_height - font:getHeight())/2,
            label = "Djikstra's",
            hover = false,
        },
        {
            y = algorithm_button_y,
            font_y = algorithm_button_y + (button_height - font:getHeight())/2,
            label = "Greedy",
            hover = false,
        },
        {
            y = algorithm_button_y,
            font_y = algorithm_button_y + (button_height - font:getHeight())/2,
            label = "A*",
            hover = false,
        },


    }

    local algorithm_button_x = (self.window_w - (#self.algorithm_buttons * (button_width) + (#self.algorithm_buttons - 1) * ( button_width/2)))/2
    local algorithm_button_gap = 1.5 * button_width
    for i, k in ipairs(self.algorithm_buttons) do
        self.algorithm_buttons[i].x = algorithm_button_x + (i - 1) * algorithm_button_gap
        self.algorithm_buttons[i].font_x = algorithm_button_x + (i - 1) * algorithm_button_gap + (button_width - font:getWidth(k.label))/2
    end
    self.algorithm_timer = 0
    self.algorithm_speed = 0.2

    self.clear_algorithm_button = {
        y = algorithm_button_y + 2 * button_height,
        font_y = algorithm_button_y + 2 * button_height + (button_height - font:getHeight())/2,
        label = "Clear Algorithm",
        hover = false,
        x = (self.window_w - button_width)/2,
        font_x = (self.window_w - button_width)/2 + (button_width - font:getWidth("Clear Algorithm"))/2
    }
    

    self.cursor = love.mouse.getSystemCursor("hand")





    self:generate_maze()
end

function Maze:generate_maze()
    self.maze = {}
    self.start_position = nil
    self.goal_position = nil
    self.clear_maze = false
    self.mode = "Drawing"

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
        

        
        if self.mode == "Drawing" then
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

            for i, k in ipairs(self.algorithm_buttons) do
                if x > k.x and x < k.x + button_width and y > k.y and y < k.y + button_height then
                    self.mode = k.label
                    love.audio.play(self.button_select_sound)
                    if (k.label == "BFS") then 
                        self.algorithm = Bfs:new(self.maze, self.start_position, self.goal_position)
                
                    elseif (k.label == "Djikstra's") then
                        self.algorithm = Djikstra:new(self.maze, self.start_position, self.goal_position)
                    elseif (k.label == "Greedy") then
                        self.algorithm = Greedy:new(self.maze, self.start_position, self.goal_position)
                    elseif (k.label == "A*") then
                        self.algorithm = AStar:new(self.maze, self.start_position, self.goal_position)
                    end

                    if self.algorithm == nil then
                        self.mode = "Drawing"
                    end
                    
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
        else

            -- Clear Algorithm Button
            if (
                x > self.clear_algorithm_button.x and 
                x < self.clear_algorithm_button.x + button_width and 
                y > self.clear_algorithm_button.y and 
                y < self.clear_algorithm_button.y + button_height
            ) then
                self.mode = "Drawing"
                self.algorithm:clear()
                self.algorithm = nil
                love.audio.play(self.button_select_sound)
            end
        end




    end
    


    

end

function Maze:handle_mouse_hold()
    if self.mode ~= "Drawing" then
        return
    end

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

    for i, k in ipairs(self.algorithm_buttons) do
        if x > k.x and x < k.x + button_width and y > k.y and y < k.y + button_height then
            self.algorithm_buttons[i].hover = true
            love.mouse.setCursor(self.cursor)
            is_hovering = true
        else
            self.algorithm_buttons[i].hover = false
        end
    end

    if (
        x > self.clear_algorithm_button.x and 
        x < self.clear_algorithm_button.x + button_width and
        y > self.clear_algorithm_button.y and
        y < self.clear_algorithm_button.y + button_height and
        self.mode ~= "Drawing"
    ) then
        self.clear_algorithm_button.hover = true
        love.mouse.setCursor(self.cursor)
        is_hovering = true
    else
        self.clear_algorithm_button.hover = false
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

    if self.mode ~= "Drawing" then
        if not self.algorithm.no_path_found and not self.algorithm.backtrack_complete then
            self.algorithm_timer = self.algorithm_timer - dt
            if self.algorithm_timer < 0 then
                self.algorithm_timer = self.algorithm_speed
                if not self.algorithm.is_goal_reached then
                    self.algorithm:step()
                else
                    self.algorithm:backtrack()
                end
            end
        else 
            -- Display message saying no path found
        end
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
            elseif self.algorithm then
                Maze:handle_algorithm_draw(row, col)
                
            end
            
        end 
    end

    Maze:draw_buttons()
    Maze:draw_algorithm_buttons()
    


end


function Maze:handle_algorithm_draw(row, col)
    if self.algorithm:checkInCameFrom({row = row, col = col}) then
        love.graphics.setColor(144/255,213/255,255/255)
        love.graphics.rectangle("fill", self.col_start + (col - 1) * maze_square_size + 1, row * maze_square_size + 1, maze_square_size - 2, maze_square_size - 2)
    end
    if self.algorithm:checkInNeighbours({row = row, col = col}) then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("line", self.col_start + (col - 1) * maze_square_size + 2, row * maze_square_size + 2, maze_square_size - 4, maze_square_size - 4)

    end

    if self.algorithm:checkInFrontier({row = row, col = col}) then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.rectangle("line", self.col_start + (col - 1) * maze_square_size, row * maze_square_size, maze_square_size, maze_square_size)

    end

    if self.algorithm:checkInPath({row = row, col = col}) then
        love.graphics.setColor(128/255,0/255,128/255)
        love.graphics.rectangle("fill", self.col_start + (col - 1) * maze_square_size + 1, row * maze_square_size + 1, maze_square_size - 2, maze_square_size - 2)

    end

    

    love.graphics.setColor(0, 0, 0)
end

function Maze:draw_buttons() 

    for i, k in ipairs(self.buttons) do
        love.graphics.rectangle("line", k.x, k.y, button_width, button_height)
        if k.hover or (k.tool == self.button_selected and self.mode == "Drawing") then
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

function Maze:draw_algorithm_buttons() 
    

    for i, k in ipairs(self.algorithm_buttons) do
        love.graphics.rectangle("line", k.x, k.y, button_width, button_height)
        if k.hover or self.mode == k.label then
            love.graphics.setColor(144/255,213/255,255/255)
            love.graphics.rectangle("fill", k.x + 1, k.y + 1, button_width - 2, button_height - 2)
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.print(k.label, k.font_x, k.font_y)
    end

    if self.mode ~= "Drawing" then
        love.graphics.rectangle(
            "line", 
            self.clear_algorithm_button.x, 
            self.clear_algorithm_button.y,
            button_width,
            button_height
        )

        if self.clear_algorithm_button.hover then
            love.graphics.setColor(144/255,213/255,255/255)
            love.graphics.rectangle(
                "fill", 
                self.clear_algorithm_button.x + 1, 
                self.clear_algorithm_button.y + 1, 
                button_width - 2, 
                button_height - 2
            )
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.print(
            self.clear_algorithm_button.label, 
            self.clear_algorithm_button.font_x, 
            self.clear_algorithm_button.font_y
        )
    end

    
end

return Maze