local Algorithm = require("src/systems/algorithms/algorithm")
local PriorityQueueAlgorithm = {
    distances = nil
}
PriorityQueueAlgorithm.__index = PriorityQueueAlgorithm
setmetatable(PriorityQueueAlgorithm, Algorithm)


function PriorityQueueAlgorithm:step()
    if #self.frontier.items ~= 0 then
        local current = self.frontier:pop()
        if current == nil then
            self.no_path_found = true
            return
        end
        self.neighbours = self:get_neighbours(current)

        for _, k in ipairs(self.neighbours) do

            if self.maze[k.row] ~= nil and self.maze[k.row][k.col] ~= nil then
                local stored_cost = self.distances[k.row][k.col].cost
                local new_cost = self:get_cost(current, k)
                
                if self.maze[k.row][k.col] ~= "Wall" and (stored_cost > new_cost) then
                    self.frontier:push({row = k.row, col = k.col, cost = new_cost})
                    self.distances[k.row] = self.distances[k.row] or {}
                    self.distances[k.row][k.col] = {cost = new_cost, previous = {
                        row = current.row, col = current.col
                    }}
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


function PriorityQueueAlgorithm:backtrack()
    if not self.is_goal_reached then
        error("Goal was not reached")
    else 
        print(self.backtrack_progress.row)
        print(self.backtrack_progress.col)
        local next_node = self.distances[self.backtrack_progress.row][self.backtrack_progress.col].previous
        print(next_node)
        print("HI")
        if next_node.row ~= self.start.row or next_node.col ~= self.start.col then
            table.insert(self.path, next_node)
            self.backtrack_progress = next_node
        else 
            self.backtrack_complete = true
        end
    end

end

function PriorityQueueAlgorithm:checkInCameFrom(tile)
    return self.distances[tile.row][tile.col].previous ~= nil
end

return PriorityQueueAlgorithm