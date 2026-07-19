local MinHeap = {}
MinHeap.__index = MinHeap


function MinHeap:new()
    local min_heap = {
        items = {},
    }
    return setmetatable(min_heap, self)
end

function MinHeap:push(item)
    table.insert(self.items, item)
    self:siftUp(#self.items)
end

function MinHeap:pop()
    if #self.items == 0 then
        return nil
    elseif #self.items == 1 then
        return table.remove(self.items, #self.items)
    else 
        self.items[1], self.items[#self.items] = self.items[#self.items], self.items[1]
        local return_value = table.remove(self.items, #self.items)
        self:siftDown(1)
        return return_value
    end
end

function MinHeap:siftUp(index)
    local parent_index = self:getParentIndex(index)
    local current_index = index

    while current_index ~= 1 and self.items[current_index].cost < self.items[parent_index].cost do
        self.items[current_index], self.items[parent_index] = self.items[parent_index], self.items[current_index]
        current_index = parent_index
        parent_index = self:getParentIndex(current_index)
    end

end

function MinHeap:siftDown(index)
    local left_index = self:getLeftChildIndex(index)
    local right_index = self:getRightChildIndex(index)
    local current_index = index
    local current_cost = self.items[index].cost

    local left_cost = nil
    local right_cost = nil

    while true do
        if left_index > #self.items then
            break
        elseif right_index > #self.items then
            left_cost = self.items[left_index].cost
            if current_cost > left_cost then
                self.items[current_index], self.items[left_index] = self.items[left_index], self.items[current_index]
                break
            end
            break
        else 
            left_cost = self.items[left_index].cost
            right_cost = self.items[right_index].cost
            if left_cost < right_cost then
                if current_cost > left_cost then
                    self.items[current_index], self.items[left_index] = self.items[left_index], self.items[current_index]
                    current_index = left_index
                else
                    break
                end
            else
                if current_cost > right_cost then
                    self.items[current_index], self.items[right_index] = self.items[right_index], self.items[current_index]
                    current_index = right_index
                else
                    break
                end
            end

            left_index = self:getLeftChildIndex(current_index)
            right_index = self:getRightChildIndex(current_index)
            current_cost = self.items[current_index].cost
            

    
        end
    end


end

function MinHeap:getLeftChildIndex(index)
    return 2 * index
end

function MinHeap:getRightChildIndex(index)
    return 2 * index + 1
end

function MinHeap:getParentIndex(index)
    return math.floor(index / 2)
end

return MinHeap