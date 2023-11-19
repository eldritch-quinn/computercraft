ccemux.attach("left", "wireless_modem", {
    -- The range of this modem
    range = 64,
  
    -- Whether this is an ender modem
    interdimensional = true,
  
    -- The current world's name. Sending messages between worlds requires an interdimensional modem
    world = "main",
  
    -- The position of this wireless modem within the world
    posX = 0, posY = 0, posZ = 0,
})
ccemux.attach("bottom", "disk_drive", {
    -- The disk's ID
    id = 0
})
local args = {...}
args = {
    title="Acquisitor",
    ipv2="1"
}

local typeUtils = require("/lua/lib/typeUtils")
local pretty = require "cc.pretty"


local DIR = "lua/programs"
local PROGRAM = "/operator.lua"
local PROGRAM_ARGS = table.concat(args, " ")


local SHELL = 1
local TAB_TITLE = ""
local IPV2 = ""





write("::"..typeUtils.length(args).." ARGS ")
if typeUtils.length(args) ~= 0 then
    if typeUtils.setContains(args, "title") then TAB_TITLE = args.title write("TAB_TITLE") end
    if typeUtils.setContains(args, "ipv2") then IPV2 = args.ipv2 write("IPV2") end
end
write(" ::\n")



local commandString = ""..DIR..''..PROGRAM..' "'..PROGRAM_ARGS..'"'

local taskTab = shell.openTab(commandString)

local processCount = multishell.getCount()
local shellProcessIndex = multishell.getCurrent()

--local proID = multishell.launch(shell.dir(), DIR..PROGRAM, PROGRAM_ARGS)

multishell.setTitle(proID, TAB_TITLE..":"..IPV2)

write(proID.." "..TAB_TITLE..":"..IPV2.."\n")
pretty.pretty_print(args)

--local newSubProcess = multishell.launch({}, DIR..PROGRAM, commandString)

--local newTask = shell.openTab(commandString)




--setFocus(n)
--shell.switchTab(processCount+1)
--local x, y = term.getCursorPos()



--multishell.setTitle(newTask, TAB_TITLE..":"..IPV2)
--shell.switchTab(newTask)

--shell.run()