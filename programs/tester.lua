local setup = require("/lua/lib/setupUtils")
local length = require("/lua/lib/typeUtils").length
local typeUtils = require("/lua/lib/typeUtils")
local pretty = require "cc.pretty"

local args = { ... }

local SHELL = 1


local maxX, maxY = term.getSize()



local function writeTableLayer(iTable, indent)

    


    indent = indent or 4
    local oldX, oldY = term.getCursorPos()
    oldY = oldY
    term.setCursorPos(1, oldY )

    
    write(" Table  {")
    if iTable == nil or length(iTable) == 0 then print(" }") end
    for i, v in ipairs( iTable ) do
        textutils.tabulate( i, colors.orange, v, colors.lightBlue )
    end
    write("}")
    term.setCursorPos(oldX, oldY)
    
end

local wrappedPers = setup.getPers({
    "modem",
    "drive",
})


--local localmodem = wrappedPers.modem[1]
local tabs = "    "
local left = true
term.clear()
term.setCursorPos(1, 1)

if 1==2 then
    for perName, per in pairs(wrappedPers) do

        local tW, tH = term.getSize()
        local oldX, oldY = term.getCursorPos()
        local leftPos = 1
        local rightPos = tW/2
        
        if left then
            
            term.setCursorPos(leftPos, 3)
            write(perName)
            term.setCursorPos(leftPos, 5)
            left = false
        else 
    
            term.setCursorPos(rightPos, 2)
            write(perName)
            term.setCursorPos(rightPos, 5)
            left = true
        end
        write(perName.." {\n")
    
        for k, v in ipairs(per) do
            if left then term.setCursorPos(leftPos, 5 + k) 
            else term.setCursorPos(rightPos, 5 + k) end
            if type(v) ~= "table" and type(v) ~= "function" then write(tabs..k.." : "..v.."\n") 
            else write(tabs..k.." : "..type(v).."\n") end
        end
    
        write("\n}")
    end
end

local renderedPers = pretty.pretty(wrappedPers)

for k,v in pairs(renderedPers) do
    shell.switchTab(1)
    term.clear()
    write(k,pretty.pretty(v))

    local processCount = multishell.getCount()
    
    local currentProcessIndex = multishell.getCurrent()

    local newSubProcess = multishell.launch({}, sProgramPath, ...)

    local newIndex = shell.openTab(pretty.print(v))

    multishell.setTitle(processCount+1, "Per")
    shell.switchTab(processCount+1)
    --local x, y = term.getCursorPos()

    --if y == maxY then write("Press any key to continue") os.pullEvent("key") clear() end
    
end

--pretty.print(renderedPers, 1)

--print(json)

if 1==2 then
    local formattedJsons = {}
    for k, v in pairs(wrappedPers) do

        local newJson = {}

        local test = 

        write(k)

        for k2, v2 in pairs(v) do

            --local json = textutils.serialiseJSON({ v }, { nbt_style = true })

            if typeUtils.setContains(args, "ipv2") then 

                IPV2 = args.ipv2 

                write("IPV2") 
            end

        end

        --table.insert(jsons, k, json) 
        --write(" - Inserted "..length(json).." Json")
        
        --for k2, v2 in pairs(v) do write(" "..k2.." : "..tostring(v2).."\n") end
    end
    for k, v in pairs(wrappedPers) do
        write(k.."\n")
        for k2, v2 in pairs(v) do
            write(" "..k2.." : "..tostring(v2).."\n")
        end
    end
    for i, v in ipairs(pers) do
        textutils.tabulate( i, colors.orange, v, colors.lightBlue )
    end
end



--print(wrappedPers.modem[1].isWireless())

if 1==2 then
    term.clear()
    term.setCursorPos(1, 4)	
    write("Hello world!\n")
    for i=1,length(wrappedPers) do
        local per = unpack(wrappedPers)
        write("->"..per.." : \n")
        local nests = 0
        while type(v) == "table" do
            local idx = typeUtils.findIndexInOf(v,i)
            write()
            writeTableLayer(wrappedPers[i])
            break
    
    
            --if peripheral.getType(v) ~= "modem" then textutils.tabulate( i, colors.orange, v, colors.lightBlue ) end
            if v.isWireless() then
                v[1] = "wireless_modem"
            end
            break
        end
        term.setTextColour(colours.white)
        break
    end
end

--textutils.tabulate(colors.orange)

--if not modem.isWireless() then print(modem.getNameLocal().." is not wireless.") end

--print(peripheral.getType(localmodem))

--local name = 

--localmodem.open(43) -- Open 43 so we can receive replies

-- Send our message
--localmodem.transmit(15, 43, localmodem.getNameLocal().." here, wuts up.")