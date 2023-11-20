local setup = require("/lua/lib/setupUtils")
local typeUtils = require("/lua/lib/typeUtils")
local monitorUtils = require("/lua/lib/monitorUtils")
--local pretty = require("cc.pretty")
local args = { ... }

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
  term.clear()
  term.setCursorPos(1, 1)
  term.write("Hello world!\nI'm '"..TAB_INDEX.."'!")
  

  print("\n > "..shell.getRunningProgram())
  print("\n > Tab Index : "..multishell.getTitle(TAB_INDEX))

  term.write(motd.."\n\n")

  local input = read()
  --local input = "msg"

  if input == nil or string.len(input) == 0 then goto continue end

  motd = ' - "'..input..'"'

  if input == "restart" then 
    --goto slash 
    multishell.setTitle(TAB_INDEX, "/")
    break
    --goto stop
  elseif input == "msg" then 
    local modem = wrappedPers.modem[1]
    if modem then 
      term.write("  - MODEM FOUND - \n msg: ")

      local inputMsg = read()
      --local inputMsg = "Test"
      modem.open(40100) -- Open 43 so we can receive replies
      modem.transmit(40100, 40100, inputMsg)
      modem.close(40100)

    end
  end

  ::continue::
end


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




--multishell.setTitle(TAB_INDEX, "/")
--local convertedTable = textutils.unserialiseJSON(testJson, { parse_null = true })

--pretty.pretty(convertedTable)