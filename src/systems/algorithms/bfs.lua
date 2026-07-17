local Queue = require("src/systems/queue")
local Algorithm = require("src/systems/algorithms/algorithm")
local Bfs = {}
Bfs.__index = Bfs
setmetatable(Bfs, Algorithm)

function Bfs:new(maze, start, goal)
    if maze == nil or start == nil or goal == nil then
        return
    end
    local queue = Queue:new()
    queue:push(start)
    return setmetatable({
        maze = maze,
    start = start,
    goal = goal,
    neighbours = {},
    frontier = queue,
    came_from = {
        [start.row] = {
            [start.col] = {row = start.row, col = start.col}
        }
    },
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


return Bfs