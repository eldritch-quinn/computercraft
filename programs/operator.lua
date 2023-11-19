local setup = require("/lua/lib/setupUtils")
local typeUtils = require("/lua/lib/typeUtils")
local pretty = require("cc.pretty")

local args = { ... }

local SHELL = 1

local wrappedPers = setup.getPers({
    "modem",
    "drive"
})

term.clear()
term.setCursorPos(1, 1)
local motd = ""

local isObject = false
local isArray = false

local testJson = '{"id":1,"rpv2":"000.001","color":"gold","array":[1,2,3],"boolean":true,"null":null,"number":123,"object":{"a":"b","c":"d"},"string":"Hello World"}'

while true do 

  while true do 

    term.write("Hello world!")
    term.write(motd)

    input = read()
    if input ~= nil or input ~= "" then
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


--local convertedTable = textutils.unserialiseJSON(testJson, { parse_null = true })

--pretty.pretty(convertedTable)