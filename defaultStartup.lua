local CLI_ARGS = { ... }
local DO_SETUP = CLI_ARGS[1] == '--setup'

local CHANNEL = "40100"
local REPO_FULL = "https://api.github.com/repos/eldritch-quinn/computercraft/contents"
local GITHUB_ACCESS_TOKEN = "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"
local DIR = "/lua"
local PROGRAM = "operator.lua"
local PROGRAM_ARGS = " 10 1 Unnamed right left front false"

shell.run(DIR..'/sync.lua '..CHANNEL..' '..REPO_FULL..' '..GITHUB_ACCESS_TOKEN..' '..DIR..' '..PROGRAM..' "'..PROGRAM_ARGS..'" '..tostring(DO_SETUP))