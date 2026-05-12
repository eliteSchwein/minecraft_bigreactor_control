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

local REACTORCONTROL_URL =
	"https://raw.githubusercontent.com/eliteSchwein/minecraft_bigreactor_control/refs/heads/master/reactorcontrol.lua"

local BOOTSTRAP_TIMEOUT = 30

local function log(msg)
	write(msg .. "\n")
end

local function readFile(path)
	local f = fs.open(path, "r")
	if not f then
		return nil
	end

	local content = f.readAll()
	f.close()

	return content
end

local function writeFile(path, content)
	local f = fs.open(path, "w")
	if not f then
		error("Could not write " .. path)
	end

	f.write(content)
	f.close()
end

local function downloadScript(name, url, timeoutSec)
	local backupName = name .. ".bak"

	if fs.exists(backupName) then
		fs.delete(backupName)
	end

	if fs.exists(name) then
		fs.copy(name, backupName)
		fs.delete(name)
	end

	local startTime = os.clock()

	repeat
		log("Downloading " .. name .. "...")

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

	if fs.exists(backupName) then
		fs.copy(backupName, name)
		fs.delete(backupName)

		log("WARNING: Download failed. Using local backup.")
		return true
	end

	error("Could not download " .. name)
end

local function patchReactorControl(path)
	local content = readFile(path)

	if not content then
		error("Could not read " .. path)
	end

	content = content:gsub("\r\n", "\n")

	local oldBlock = [[
						if pos == nil then
							printLog("Skipping malformed line in "..path..": "..line, WARN)
							found = true
							continue
						end
						line = line:gsub("#_!36!_#", ";")
						line = line:gsub("#_!71!_#", "=")
						tab[currentTag][stringTrim(line:sub(1, pos-1))] = stringTrim(line:sub(pos+1, line:len()))
						found = true]]

	local newBlock = [[
						if pos == nil then
							printLog("Skipping malformed line in "..path..": "..line, WARN)
							found = true
						else
							line = line:gsub("#_!36!_#", ";")
							line = line:gsub("#_!71!_#", "=")
							tab[currentTag][stringTrim(line:sub(1, pos-1))] = stringTrim(line:sub(pos+1, line:len()))
							found = true
						end]]

	local patched, count = content:gsub(oldBlock, newBlock, 1)

	if count < 1 then
		log("WARNING: Exact patch failed, trying fallback patch.")

		patched = content:gsub("\n%s*continue%s*\n", "\n", 1)
	end

	writeFile(path, patched)
	log("Patched " .. path)
end

downloadScript("reactorcontrol", REACTORCONTROL_URL, BOOTSTRAP_TIMEOUT)
patchReactorControl("reactorcontrol")

shell.run("reactorcontrol")