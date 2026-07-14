local Queue = {}
Queue.__index = Queue


function Queue:new()
    local queue = {
        items = {}
    }
    return setmetatable(queue, self)
end

function Queue:push(item)
    table.insert(self.items, item)
end

function Queue:pop()
    table.remove(self.items, 1)
end