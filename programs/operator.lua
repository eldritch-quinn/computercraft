local setup = require("/lua/lib/setupUtils")
local typeUtils = require("/lua/lib/typeUtils")
local pretty = require("cc.pretty")

local args = { ... }

local SHELL = 1

local wrappedPers = setup.getPers({
    "modem",
    "drive"
})



local isObject = false
local isArray = false
term.clear()
term.setCursorPos(1, 1)
local testJson = '{"id":1,"rpv2":"000.001","color":"gold","array":[1,2,3],"boolean":true,"null":null,"number":123,"object":{"a":"b","c":"d"},"string":"Hello World"}'
while true do 

  local motd = ""

  term.write("Hello world!")
  while true do 
    input = read()
    if input ~ nil or input ~ "" then
      break -- Break out of the infinite loop

    end
  end

  motd = ' - "'..input..'"'
  if 1==2 then
    if disk.isPresent("bottom") then
      local name = disk.getLabel("bottom")
  
      term.write("Disk loaded:")
  
      mon.write(name)
    elseif mon then
      mon.write("No disk loaded")
    else
      print("No monitor available")
    end
  end


end

while true do
  sInput = read()
  if sInput ~= nil or sInput ~= "" then
        break -- Break out of the infinite loop
         -- Monitor code goes here
  end
end

--local convertedTable = textutils.unserialiseJSON(testJson, { parse_null = true })

--pretty.pretty(convertedTable)