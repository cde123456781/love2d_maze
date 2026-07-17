local Algorithm = {
    maze = nil,
    start = nil,
    goal = nil,
    neighbours = nil,
    frontier = nil,
    came_from = nil,
    is_goal_reached = false,
    no_path_found = false,
    backtrack_complete = false,
    path = nil,
    backtrack_progress = nil
}
Algorithm.__index = Algorithm



function Algorithm:get_neighbours(current_tile)
    local current_row = current_tile.row
    local current_col = current_tile.col
    local neighbours_to_check = {
        {
            row = current_row,
            col = current_col - 1
        },
        {
            row = current_row + 1,
            col = current_col
        },
        {
            row = current_row,
            col = current_col + 1
        },
        {
            row = current_row - 1,
            col = current_col
        }
    }

    return neighbours_to_check
end

function Algorithm:checkInCameFrom(tile)
    return self.came_from[tile.row] and self.came_from[tile.row][tile.col]
end

function Algorithm:checkInFrontier(tile)
    for _, k in ipairs(self.frontier.items) do
        if k.col == tile.col and k.row == tile.row then
            return true
        end

    end

    return false
end

function Algorithm:checkInNeighbours(tile)
    for _, k in ipairs(self.neighbours) do
        if k.col == tile.col and k.row == tile.row then
            return true
        end

    end

    return false

end

function Algorithm:checkInPath(tile)
    for _, k in pairs(self.path) do
        if k.col == tile.col and k.row == tile.row then
            return true
        end

    end

    return false

end


function Algorithm:step()
    if #self.frontier.items ~= 0 then
        local current = self.frontier:pop()
        if current == nil then
            self.no_path_found = true
            return
        end
        self.neighbours = self:get_neighbours(current)

        for _, k in ipairs(self.neighbours) do

            if self.maze[k.row] ~= nil then
                
                if self.maze[k.row][k.col] ~= nil and self.maze[k.row][k.col] ~= "Wall" and (self.came_from[k.row] == nil or self.came_from[k.row][k.col] == nil) then
                    self.frontier:push({row = k.row, col = k.col})
                    self.came_from[k.row] = self.came_from[k.row] or {}
                    self.came_from[k.row][k.col] = {row = current.row, col = current.col}
                    if self.goal.col == k.col and self.goal.row == k.row then
                        self.is_goal_reached = true
                        break
                    end
                end
            end
        end
        
    else 
        self.no_path_found = true
    end

end

function Algorithm:backtrack()
    if not self.is_goal_reached then
        error("Goal was not reached")
    else 
        local next_node = self.came_from[self.backtrack_progress.row][self.backtrack_progress.col]
        if next_node.row ~= self.start.row or next_node.col ~= self.start.col then
            table.insert(self.path, next_node)
            self.backtrack_progress = next_node
            print(tostring(self.backtrack_progress.row)..","..tostring(self.backtrack_progress.col))
        else 
            self.backtrack_complete = true
        end
    end

end


function Algorithm:clear()
    self.table = nil
    self.start = nil
    self.goal = nil
    self.neighbours = nil
    self.frontier = nil
    self.came_from = nil
    self.is_goal_reached = nil
    self.no_path_found = nil
    self.backtrack_complete = nil
    self.path = nil
    self.backtrack_progress = nil

end


return Algorithm