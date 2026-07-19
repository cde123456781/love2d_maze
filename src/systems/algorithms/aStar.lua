local MinHeap = require("src/systems/minHeap")
local PriorityQueueAlgorithm = require("src/systems/algorithms/priorityQueueAlgorithm")
local AStar = {}
AStar.__index = AStar
setmetatable(AStar, PriorityQueueAlgorithm)

function AStar:new(maze, start, goal)
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

function AStar:get_cost(current_tile, neighbour)
    local cost_to_neighbour = self.distances[current_tile.row][current_tile.col].cost + 1
    local heuristic = math.abs(self.goal.row - neighbour.row) + math.abs(self.goal.col - neighbour.col)
    return cost_to_neighbour + heuristic
end




return AStar