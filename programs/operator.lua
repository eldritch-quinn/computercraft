local setup = require("/lua/lib/setupUtils")
local length = require("/lua/lib/typeUtils").length
local typeUtils = require("/lua/lib/typeUtils")
local pretty = require "cc.pretty"

local args = { ... }

local SHELL = 1

local wrappedPers = setup.getPers({
    "modem",
    "drive",
})



local isObject = false
local isArray = false

local testJson = '{"id":1,"rpv2":"000.001","color":"gold","array":[1,2,3],"boolean":true,"null":null,"number":123,"object":{"a":"b","c":"d"},"string":"Hello World"}'



if disk.isPresent("right") then
    local name = disk.getLabel("right")
   
    vrtapi.resetScrn(mon)
    mon.write("Disk loaded:")
    vrtapi.newLine(mon)
    mon.write(name)
  elseif mon then
    mon.write("No disk loaded")
  else
    print("No monitor available")
  end
  

local convertedTable = textutils.unserialiseJSON(testJson, { parse_null = true })

pretty.pretty(convertedTable)