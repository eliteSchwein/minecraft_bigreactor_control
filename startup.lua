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

local function log(msg)
	write(msg .. "\n")
end

local function backupFile(name)
	local backupName = name .. ".bak"

	if fs.exists(backupName) then
		fs.delete(backupName)
	end

	if fs.exists(name) then
		fs.copy(name, backupName)
	end

	return backupName
end

local function restoreBackup(name, backupName)
	if fs.exists(backupName) then
		if fs.exists(name) then
			fs.delete(name)
		end

		fs.copy(backupName, name)
		fs.delete(backupName)

		return true
	end

	return false
end

local function downloadScript(name, url, timeoutSec)
	local backupName = backupFile(name)

	if fs.exists(name) then
		fs.delete(name)
	end

	local startTime = os.clock()

	repeat
		log("Downloading " .. name .. "...")

		if fs.exists(name) then
			fs.delete(name)
		end

		local ok = shell.run("wget", url, name)

		if ok == true or ok == 0 then
			if fs.exists(backupName) then
				fs.delete(backupName)
			end

			log("Downloaded as " .. name .. ".")
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

	if restoreBackup(name, backupName) then
		log("WARNING: Could not download " .. name .. ". Using local backup.")
		return true
	end

	error("Could not download " .. name .. ". No local backup available.")
end

local function readFile(name)
	local f = fs.open(name, "r")
	if not f then
		return nil
	end

	local content = f.readAll()
	f.close()

	return content
end

local function writeFile(name, content)
	local f = fs.open(name, "w")
	if not f then
		error("Could not open " .. name .. " for writing.")
	end

	f.write(content)
	f.close()
end

local function patchReactorControl(name)
	local content = readFile(name)

	if not content then
		error("Could not read " .. name .. " for patching.")
	end

	local original = content

	-- ComputerCraft Lua has no "continue".
	-- This fixes the known malformed-line parser block.
	content = string.gsub(
		content,
		"if pos == nil then printLog%((.-)%, WARN%) found = true continue end line = line:gsub%(",
		"if pos == nil then printLog(%1, WARN) found = true else line = line:gsub("
	)

	content = string.gsub(
		content,
		"tab%[currentTag%]%[stringTrim%(line:sub%(1, pos%-1%)%)%] = stringTrim%(line:sub%(pos%+1, line:len%(%)%)%) found = true end end line = f.readLine%(%)",
		"tab[currentTag][stringTrim(line:sub(1, pos-1))] = stringTrim(line:sub(pos+1, line:len())) found = true end end end line = f.readLine()"
	)

	if content ~= original then
		writeFile(name, content)
		log("Patched " .. name .. " for ComputerCraft Lua compatibility.")
	else
		log("No patch needed for " .. name .. ".")
	end
end

local function verifyVersion(name)
	local content = readFile(name)

	if not content then
		log("WARNING: Could not verify " .. name .. " version.")
		return
	end

	if string.find(content, "Version: v" .. CONTROL_VERSION, 1, true) then
		log("Loaded reactorcontrol v" .. CONTROL_VERSION)
	else
		log("WARNING: Loaded reactorcontrol has unexpected version info. Expected v" .. CONTROL_VERSION)
	end
end

-- Optional self-update.
-- Comment this out if you do not want startup to replace itself.
downloadScript("startup", STARTUP_URL, BOOTSTRAP_TIMEOUT)

downloadScript("reactorcontrol", REACTORCONTROL_URL, BOOTSTRAP_TIMEOUT)
patchReactorControl("reactorcontrol")
verifyVersion("reactorcontrol")

shell.run("reactorcontrol")