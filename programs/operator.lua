local setup = require("/lua/lib/setupUtils")

--local pretty = require("cc.pretty")
local args = { ... }

local wrappedPers = setup.getPers({
    "modem",
    "drive"
})
local isObject = false
local isArray = false

local testJson = '{"id":1,"rpv2":"000.001","color":"gold","array":[1,2,3],"boolean":true,"null":null,"number":123,"object":{"a":"b","c":"d"},"string":"Hello World"}'


while true do 
  
end





--multishell.setTitle(TAB_INDEX, "/")
--local convertedTable = textutils.unserialiseJSON(testJson, { parse_null = true })

--pretty.pretty(convertedTable)