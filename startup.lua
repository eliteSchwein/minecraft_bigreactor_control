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

local CONTROL_VERSION = "0.3.19"

local STARTUP_URL =
	"https://raw.githubusercontent.com/eliteSchwein/minecraft_bigreactor_control/refs/heads/master/startup.lua"

local REACTORCONTROL_URL =
	"https://raw.githubusercontent.com/eliteSchwein/minecraft_bigreactor_control/refs/heads/master/reactorcontrol.lua"

local BOOTSTRAP_TIMEOUT = 30

local function downloadScript(name, url, timeoutSec)
	local hadLocalCopy = fs.exists(name)
	local backupName = name .. ".bak"

	if hadLocalCopy then
		if fs.exists(backupName) then
			fs.delete(backupName)
		end

		fs.copy(name, backupName)
		fs.delete(name)
	end

	local startTime = os.clock()

	repeat
		local result = shell.run("wget", url, name)

		if result == true or result == 0 then
			if fs.exists(backupName) then
				fs.delete(backupName)
			end

			return true
		end

		if fs.exists(name) then
			fs.delete(name)
		end

		if os.clock() - startTime > timeoutSec then
			break
		end

		os.sleep(2)
	until false

	if fs.exists(backupName) then
		fs.copy(backupName, name)
		fs.delete(backupName)

		write("WARNING: Could not download " .. name .. ". Using local backup.\n")
		return true
	end

	error("Could not download " .. name .. ". No local backup available.")
end

-- Optional self-update of startup.
-- Enabled: keeps startup.lua synced with GitHub.
-- Disable this block if you do not want startup to update itself.
downloadScript("startup", STARTUP_URL, BOOTSTRAP_TIMEOUT)

-- Download reactorcontrol from GitHub raw URL.
downloadScript("reactorcontrol", REACTORCONTROL_URL, BOOTSTRAP_TIMEOUT)

-- Verify reactorcontrol version if the file exposes it in the first line.
if fs.exists("reactorcontrol") then
	local f = fs.open("reactorcontrol", "r")

	if f then
		local firstLine = f.readLine()
		f.close()

		if firstLine and string.find(firstLine, "Version: v" .. CONTROL_VERSION) then
			write("Loaded reactorcontrol v" .. CONTROL_VERSION .. "\n")
		else
			write("WARNING: Loaded reactorcontrol has unexpected version info. Expected v" .. CONTROL_VERSION .. "\n")
		end
	end
end

shell.run("reactorcontrol")