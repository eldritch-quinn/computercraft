local ARGS = { ... }
local CHANNEL = tonumber(ARGS[1]) or 40100
local TAB_INDEX = ARGS[2]
local REPO_FULL = ARGS[3]
local GITHUB_ACCESS_TOKEN = ARGS[4]
local DIR = ARGS[5]
local PROGRAM = ARGS[6]
local PROGRAM_ARGS = ARGS[7]
local DO_SETUP = ARGS[8] == "true" or false

local PROCESS_DEBUG_INFORMATION = {

    "STATUS", "STARTING",
    "PROGRAM", PROGRAM,
    "RUNNING","sync.lua",
    "CHANNEL", CHANNEL,
    "DIR", DIR,

}

local DEPS = {}

local CRASHED = false

local function printConfig()
    print(" > Configuration")
    print("    - Channel: "..CHANNEL)
    print("    - Channel: "..CHANNEL)
    print("    - Full Repo URL: "..REPO_FULL)
    print("    - GitHub Access Token: "..GITHUB_ACCESS_TOKEN)
    print("    - Directory: "..DIR)
    print("    - Program: "..PROGRAM..PROGRAM_ARGS)
end

local function printProcessInformation()
    term.clear()

    term.setCursorPos(1,1)
    print(" > Configuration")
    term.setCursorPos(4,2)
    for k, v in pairs(PROCESS_DEBUG_INFORMATION) do
        write(" > "..k.."  : "..v.."\n")
        --term.setCursorPos(5,term.getCursorPos().y + 1)
    end
    
    
    --print("     > PROGRAM : "..PROCESS_DEBUG_INFORMATION.PROGRAM)
    --print("     > RUNNING : "..PROCESS_DEBUG_INFORMATION.RUNNING)
    --print("     > CHANNEL : "..PROCESS_DEBUG_INFORMATION.CHANNEL)
    --print("     > DIR     : "..PROCESS_DEBUG_INFORMATION.DIR)
end

local function decode64(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

local function getFileFromRepo(file)
    local res = http.get(REPO_FULL..file, {
        ["Authorization"] = "token "..GITHUB_ACCESS_TOKEN,
    })
    if res == nil then return nil end
    local body = textutils.unserialiseJSON(res.readAll())
    local content = body["content"]
    res.close()
    
    if content == nil then
        error("Critical error, could not download "..PROGRAM.." from repo!")
    end
    return decode64(content)
end

local function saveFile(content, path)
    local f = fs.open(path, "w")
    f.write(content)
    f.close()
end

local function getAndSave(repo_path, save_path)
    local content = getFileFromRepo(repo_path)
    saveFile(content, save_path)
end

local function getAndSaveServer()
    print("\n > Downloading sync client")
    print("   - Downloading sync.lua from repo")
    getAndSave("/sync.lua", DIR.."/sync.lua")
    print(" - Sync client download successful")
end

local function getAndSaveProgram()
    print("\n > Downloading program")
    print("   - Downloading "..PROGRAM.." from repo")
    getAndSave("/programs/"..PROGRAM, DIR.."/programs/"..PROGRAM)
    print(" - Program download successful")
end

local function getAndSaveDeps()
    print("\n > Downloading dependencies ("..#DEPS..")")
    for _,dep in ipairs(DEPS) do
        print("   - Downloading "..dep.." from repo")
        getAndSave("/lib/"..dep, DIR.."/lib/"..dep)
    end
    print(" - Dependency download successful")
end

local function tableHasValue(tab, value)
    for _,v in ipairs(tab) do
        if v == value then return true end
    end
    return false
end

local function getDeps(path, quiet)
    local content = getFileFromRepo(path)

    local matches = content:gmatch('require%(.'..DIR..'/lib/(.-).%)')

    local function insertDep(dep)
        if not tableHasValue(DEPS, dep) then
            table.insert(DEPS, dep)
            return true
        end
        return false
    end

    for str in matches do
        local success = insertDep(str..".lua")
        if success then
            if not quiet then
                print("   - Found "..str..".lua")
            end
            getDeps("/lib/"..str..".lua", quiet)
        else
            if not quiet then
                print("   - Already found "..str..".lua")
            end
        end
    end
    
    return deps
end

local function getProgramDeps(quiet)
    if not quiet then print("\n > Gathering Dependencies") end
    DEPS = {}
    getDeps("/programs/"..PROGRAM, quiet)
    if not quiet then print(" - Found "..#DEPS.." dependencies")end
end

local function isFirstRun()
    return not fs.exists(DIR.."/programs/"..PROGRAM)
end

local function runFirstTimeSetup()
    print("\n > Running first time setup")
    getProgramDeps()
    getAndSaveProgram()
    getAndSaveDeps()
    print("\n > First time setup complete")
end

local function startProgram()

    --local shellIndex = multishell.getFocus()
    local currentProcessCount = multishell.getCount()

    if TAB_INDEX == "+" then

        --print("\n <---> Starting Program")



        --print("\n Program opening on Tab "..TAB_INDEX)

        local tab = shell.openTab("bg "..DIR.."/programs/"..PROGRAM..PROGRAM_ARGS);
        --if tab == nil then CRASHED = true end

        TAB_INDEX = tab

        multishell.setTitle(TAB_INDEX, "/"..multishell.getTitle(TAB_INDEX))
        
    else 
        --print("\n <---> "..PROGRAM.." Running on Tab "..TAB_INDEX)
        --print("\n    > runningProgram : "..shell.getRunningProgram())
        --print("\n    > operator resolved path : "..shell.resolve(PROGRAM))
        --print("\n")
    end

    printProcessInformation()

    --if multishell.getTitle(TAB_INDEX) == "/" and multishell.getFocus() ~= TAB_INDEX then CRASHED = true print("\n <---> Program Exited") end
end

local function startListener()
    print("\n <---> Starting Listener")
    local modem = peripheral.find("modem")
    if modem then modem.open(CHANNEL) end
    if modem == nil then print("\n <---> No modem present, networking disabled") end

    local needsRestart = false

    while not needsRestart do
        local event, _, _, _, body = os.pullEvent()

        if event == "modem_message" then
            if body.type == "update" then
                local changedPrograms = body.programs
                local changedDeps = body.deps
                local serverChanged = body.server
                local updateAll = body.all;
                getProgramDeps(true)

                local changes = {}

                if (changedPrograms ~= nil and tableHasValue(changedPrograms, PROGRAM)) or updateAll then
                    print("\n <---> Recieved update signal")
                    getAndSaveProgram()
                    getAndSaveDeps()
                    table.insert(changes, PROGRAM)
                elseif changedDeps ~= nil then
                    print("\n <---> Recieved update signal")
                    local relevantDeps = {}
                    for _,dep in ipairs(DEPS) do
                        if tableHasValue(changedDeps, dep) then
                            table.insert(relevantDeps, dep)
                            table.insert(changes, dep)
                        end
                    end

                    if #relevantDeps > 0 then
                        getAndSaveDeps()
                    end
                end

                if serverChanged or updateAll then
                    getAndSaveServer()
                    print("\n <---> Server updated, rebooting in 5...")
                    os.sleep(5)
                    os.reboot()
                end
 
                if #changes > 0 then
                    print("\n <---> Updates downloaded, restarting...")
                    os.sleep(1)
                    needsRestart = true
                end
            end
        end
    end
    print("\n <---> Listener Exited")
end

local function startThreads()
    while not CRASHED do 
        PROCESS_DEBUG_INFORMATION.RUNNING = multishell.getTitle(multishell.getCurrent())
        PROCESS_DEBUG_INFORMATION.FOCUSED = multishell.getTitle(multishell.getFocus())

        parallel.waitForAny(startListener, startProgram)
        sleep(0.5)
        
    end

    print("\n <---> Crash detected, closing crashed tab...")


    --startListener()
end

local function start()

    print(" > Starting Sync Server")

    if isFirstRun() or DO_SETUP then
        runFirstTimeSetup()
    end

    while true do
        CRASHED = false
        startThreads();
    end
    
end

start()