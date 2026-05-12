--[[
	Programmer: Lolmer, eliteSCHW31N
	Last update: 2026-04-17
	GitHub: https://github.com/eliteSchwein/minecraft_bigreactor_control

	Description:
	This startup script downloads and runs reactorcontrol.lua
	using wget instead of pastebin.

	Save this file as "startup" on your ComputerCraft computer.
]]--

os.setComputerLabel("ReactorControl")

local SCRIPT_NAME = "reactor_manager"

local REACTOR_MANAGER_URL =
	"https://raw.githubusercontent.com/eliteSchwein/minecraft_bigreactor_control/refs/heads/master/reactor_manager.lua"

local function log(msg)
	write(msg .. "\n")
end

local function forceDownload(name, url)
	if fs.exists(name) then
		fs.delete(name)
	end

	log("Force downloading " .. name .. "...")

	local ok = shell.run("wget", url, name)

	if ok ~= true and ok ~= 0 then
		error("Could not download " .. name)
	end

	log("Downloaded as " .. name .. ".")
end

forceDownload(SCRIPT_NAME, REACTOR_MANAGER_URL)

shell.run(SCRIPT_NAME)