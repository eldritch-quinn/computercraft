local M = {}

function M.split (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end



function M.setContains(set, key)
    return set[key] ~= nil
end

function M.keysOfSet(set) 
    local ret={} 
    for k,_ in pairs(set) do 
        ret[#ret+1]=k 
    end 
    return ret 
end

function M.findIndexInOf(set, key) 
    local index = nil
    for k, v in pairs(set) do 
        if k == key or v == key then index = #set+1 break end
    end 
    return index 
end

function M.length(T)
    if type(T) == "table" then
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    elseif type(T) == "string" then

    end
end

return M