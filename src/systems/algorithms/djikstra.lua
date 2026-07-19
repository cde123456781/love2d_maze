local MinHeap = require("src/systems/minHeap")
local PriorityQueueAlgorithm = require("src/systems/algorithms/priorityQueueAlgorithm")
local Djikstra = {}
Djikstra.__index = Djikstra
setmetatable(Djikstra, PriorityQueueAlgorithm)

function Djikstra:new(maze, start, goal)
    if maze == nil or start == nil or goal == nil then
        return
    end
    local min_heap = MinHeap:new()
    local start_table = {
        row = start.row,
        col = start.col,
        cost = 0
    }
    min_heap:push(start_table)

    local distances = {}

    for i, k in ipairs(maze) do
        distances[i] = {}
        for j, l in ipairs(k) do
            distances[i][j] = {
                cost = math.huge,
                previous = nil
            }
        end
    end

    distances[start.row][start.col].cost = 0
    return setmetatable({
        maze = maze,
    start = start,
    goal = goal,
    neighbours = {},
    frontier = min_heap,
    distances = distances,
    path = {},
    backtrack_progress = {row = goal.row, col = goal.col}

    }, self

    )


    --[[
    self.is_goal_reached = false
    self.no_path_found = false
    self.backtrack_complete = false
    ]]

end

function Djikstra:get_cost(current_tile, neighbour)
    return self.distances[current_tile.row][current_tile.col].cost + 1
end




return Djikstra