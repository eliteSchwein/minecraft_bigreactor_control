--[[
Program name: Lolmer's EZ-NUKE reactor control system
Version: v0.3.20
Programmer: Lolmer, eliteSCHW31N
With great assistance from @mechaet and @thetaphi
Last update: 2026-05-12
Pastebin: http://pastebin.com/fguScPBQ
GitHub: https://github.com/sandalle/minecraft_bigreactor_control

Description:
This program controls a Big Reactors nuclear reactor in Minecraft with a Computercraft computer, using Computercraft's own wired modem connected to the reactors computer control port.

These scripts are known to run on:
- Minecraft 1.6.4
        - NST Diet (https://www.technicpack.net/modpack/never-stop-toasting-diet.254882)
        - NST Maxx (https://www.technicpack.net/modpack/nstmaxx.398172)

- Minecraft 1.7.10
        - FTB Infinity (http://www.feed-the-beast.com/modpacks/FTBInfinity)
        - Modderation: Permabanned (https://www.technicpack.net/modpack/modderation-permabanned-edition.449941)
        - Modderation: FYAD (https://www.technicpack.net/modpack/modderation-fyad-edition.696257)

- Minecraft 1.12:
        - All the Mods 3 (https://minecraft.curseforge.com/projects/all-the-mods-3)

To simplify the code and guesswork, I assume the following monitor layout, where each "monitor" listed below is a collection of three wide by two high Advanced Monitors:
1) One Advanced Monitor for overall status display plus
	one or more Reactors plus
	none or more Turbines.
2) One Advanced Monitor for overall status display plus (furthest monitor from computer by cable length)
	one Advanced Monitor for each connected Reactor plus (subsequent found monitors)
	one Advanced Monitor for each connected Turbine (last group of monitors found).
If you enable debug mode, add one additional Advanced Monitor for #1 or #2.

Notes
----------------------------
- Only one reactor and one, two, and three turbines have been tested with the above, but IN THEORY any number is supported.
- Devices are found in the reverse order they are plugged in, so monitor_10 will be found before monitor_9.

When using actively cooled reactors with turbines, keep the following in mind:
- 1 mB steam carries up to 10RF of potential energy to extract in a turbine.
- Actively cooled reactors produce steam, not power.
- You will need about 10 mB of water for each 1 mB of steam that you want to create in a 7^3 reactor.
- Two 15x15x14 Turbines can output 260K RF/t by just one 7^3 (four rods) reactor putting out 4k mB steam.

Features
----------------------------
- Configurable min/max energy buffer and min/max temperature via ReactorOptions file.
- Disengages coils and minimizes flow for turbines over max energy buffer.
- ReactorOptions is read on start and then current values are saved every program cycle.
- Rod Control value in ReactorOptions is only useful for initial start, after that the program saves the current Rod Control average over all Fuel Rods for next boot.
- Auto-adjusts control rods per reactor to maintain temperature.
- Will display reactor data to all attached monitors of correct dimensions.
	- For multiple monitors, the first monitor (often last plugged in) is the overall status monitor.
- For multiple monitors, the first monitor (often last plugged in) is the overall status monitor.
- A new cruise mode from mechaet, ONLINE will be "blue" when active, to keep your actively cooled reactors running smoothly.

GUI Usage
----------------------------
- Right-clicking between "< * >" of the last row of a monitor alternates the device selection between Reactor, Turbine, and Status output.
	- Right-clicking "<" and ">" switches between connected devices, starting with the currently selected type, but not limited to them.
- The other "<" and ">" buttons, when right-clicked with the mouse, will decrease and increase, respectively, the values assigned to the monitor:
	- "Rod (%)" will lower/raise the Reactor Control Rods for that Reactor
	- "mB/t" will lower/raise the Turbine Flow Rate maximum for that Turbine
	- "RPM" will lower/raise the target Turbine RPM for that Turbine
- Right-clicking between the "<" and ">" (not on them) will disable auto-adjust of that value for attached device.
	- Right-clicking on the "Enabled" or "Disabled" text for auto-adjust will do the same.
- Right-clicking on "ONLINE" or "OFFLINE" at the top-right will toggle the state of attached device.

Default values
----------------------------
- Rod Control: 90% (Let's start off safe and then power up as we can)
- Minimum Energy Buffer: 15% (will power on below this value)
- Maximum Energy Buffer: 85% (will power off above this value)
- Minimum Passive Cooling Temperature: 950^C (will raise control rods below this value)
- Maximum Passive Cooling Temperature: 1,400^C (will lower control rods above this value)
- Minimum Active Cooling Temperature: 300^C (will raise the control rods below this value)
- Maximum Active Cooling Temperature: 420^C (will lower control rods above this value)
- Optimal Turbine RPM:  900, 1,800, or 2,700 (divisible by 900)
	- New user-controlled option for target speed of turbines, defaults to 2726RPM, which is high-optimal.

Requirements
----------------------------
- Advanced Monitor size is X: 29, Y: 12 with a 3x2 size
- Computer or Advanced Computer
- Modems (not wireless) connecting each of the Computer to both the Advanced Monitor and Reactor Computer Port.
- Big Reactors (http://www.big-reactors.com/) 0.3.2A+ or Extreme Reactors (https://minecraft.curseforge.com/projects/extreme-reactors)
- Computercraft (http://computercraft.info/) 1.58, 1.63+, 1.73+, or 1.80pr1+
- Reset the computer any time number of connected devices change.

Resources
----------------------------
- This script is available from:
	- http://pastebin.com/fguScPBQ
	- https://github.com/sandalle/minecraft_bigreactor_control

- Start-up script is available from:
	- http://pastebin.com/ZTMzRLez
	- https://github.com/sandalle/minecraft_bigreactor_control
- Other reactor control program which I based my program on:
	- http://pastebin.com/aMAu4X5J (ScatmanJohn)
	- http://pastebin.com/HjUVNDau (version ScatmanJohn based his on)
- A simpler Big Reactor control program is available from:
	- http://pastebin.com/7S5xCvgL (IronClaymore only for passively cooled reactors)
- Reactor Computer Port API: http://wiki.technicpack.net/Reactor_Computer_Port
- Computercraft API: http://computercraft.info/wiki/Category:APIs
- Big Reactors Efficiency, Speculation and Questions! http://www.reddit.com/r/feedthebeast/comments/1vzds0/big_reactors_efficiency_speculation_and_questions/
- Big Reactors API code: https://github.com/erogenousbeef/BigReactors/blob/master/erogenousbeef/bigreactors/common/multiblock/tileentity/TileEntityReactorComputerPort.java
- Big Reactors API: http://big-reactors.com/cc_api.html
- Big Reactor Simulator from http://reddit.com/r/feedthebeast : http://br.sidoh.org/
- A tutorial from FTB's rhn : http://forum.feed-the-beast.com/threads/rhns-continued-adventures-a-build-journal-guide-collection-etc.42664/page-10#post-657819

ChangeLog
============================
- 0.3.18
	Fix Issue #61 (Reactor Online/Offline input non-responsive when reactor is converted from passive to active cooled).

Prior ChangeLogs are posted at https://github.com/sandalle/minecraft_bigreactor_control/releases

TODO
============================
See https://github.com/sandalle/minecraft_bigreactor_control/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement :)

]]--


-- Some global variables
local progVer = "0.3.19"
local progName = "EZ-NUKE"
local sideClick, xClick, yClick = nil, 0, 0
local loopTime = 2
local controlRodAdjustAmount = 1 -- Default Reactor Rod Control % adjustment amount
local flowRateAdjustAmount = 25 -- Default Turbine Flow Rate in mB adjustment amount
local debugMode = false
-- End multi-reactor cleanup section
local minStoredEnergyPercent = nil -- Max energy % to store before activate
local maxStoredEnergyPercent = nil -- Max energy % to store before shutdown
local monitorList = {} -- Empty monitor array
local monitorNames = {} -- Empty array of monitor names
local reactorList = {} -- Empty reactor array
local reactorNames = {} -- Empty array of reactor names
local turbineList = {} -- Empty turbine array
local turbineNames = {} -- Empty array of turbine names
local monitorAssignments = {} -- Empty array of monitor - "what to display" assignments
local monitorOptionFileName = "monitors.options" -- File for saving the monitor assignments
local knowinglyOverride = false -- Issue #39 Allow the user to override safe values, currently only enabled for actively cooled reactor min/max temperature
local steamRequested = 0 -- Sum of Turbine Flow Rate in mB
local steamDelivered = 0 -- Sum of Active Reactor steam output in mB (reset each loop)
local peripheralReinitPending = false -- Debounce flag for peripheral re-initialization

-- Log levels
local FATAL = 16
local ERROR = 8
local WARN = 4
local INFO = 2
local DEBUG = 1

term.clear()
term.setCursorPos(2,1)
write("Initializing program...\n")


-- File needs to exist for append "a" later and zero it out if it already exists
-- Always initalize this file to avoid confusion with old files and the latest run
local logFile = fs.open("reactorcontrol.log", "w")
if logFile then
	logFile.writeLine("Minecraft time: Day "..os.day().." at "..textutils.formatTime(os.time(),true))
	logFile.close()
else
		-- Non-fatal: fall back to console-only mode
		write("WARNING: Could not open reactorcontrol.log for writing. Logging to console only.\n")
end


-- Helper functions

local function termRestore()
	local ccVersion = nil
	ccVersion = os.version()

	if ccVersion == "CraftOS 1.6" or ccVersion == "CraftOS 1.7" then
		term.redirect(term.native())
	elseif ccVersion == "CraftOS 1.5" then
		term.restore()
	else -- Default to older term.restore
		printLog("Unsupported CraftOS found. Reported version is \""..ccVersion.."\".")
		term.restore()
	end -- if ccVersion
end -- function termRestore()

local function printLog(printStr, logLevel)
	logLevel = logLevel or INFO
	-- No, I'm not going to write full syslog style levels. But this makes it a little easier filtering and finding stuff in the logfile.
	-- Since you're already looking at it, you can adjust your preferred log level right here.
	if debugMode and (logLevel >= WARN) then
		-- If multiple monitors, print to all of them
		for monitorName, deviceData in pairs(monitorAssignments) do
			if deviceData.type == "Debug" then
				debugMonitor = monitorList[deviceData.index]
				if(not debugMonitor) or (not debugMonitor.getSize()) then
					term.write("printLog(): debug monitor "..monitorName.." failed")
				else
					term.redirect(debugMonitor) -- Redirect to selected monitor
					debugMonitor.setTextScale(0.5) -- Fit more logs on screen
					local color = colors.lightGray
					if (logLevel == WARN) then
						color = colors.white
					elseif (logLevel == ERROR) then
						color = colors.red
					elseif (logLevel == FATAL) then
						color = colors.black
						debugMonitor.setBackgroundColor(colors.red)
					end
					debugMonitor.setTextColor(color)
					write(printStr.."\n")   -- May need to use term.scroll(x) if we output too much, not sure
					debugMonitor.setBackgroundColor(colors.black)
					termRestore()
				end
			end
		end -- for

		local logFile = fs.open("reactorcontrol.log", "a") -- See http://computercraft.info/wiki/Fs.open
		if logFile then
			logFile.writeLine(printStr)
			logFile.close()
		else
			error("Cannot open file reactorcontrol.log for appending!")
		end -- if logFile then
	end -- if debugMode then
end -- function printLog(printStr)



-- Trim a string
local function stringTrim(s)
	assert(s ~= nil, "String can't be nil")
	return(string.gsub(s, "^%s*(.-)%s*$", "%1"))
end



-- Format number with [k,M,G,T,P,E] postfix or exponent, depending on how large it is
local function formatReadableSIUnit(num)
	printLog("formatReadableSIUnit("..num..")", DEBUG)
	num = tonumber(num)
	if(num < 1000) then return tostring(num) end
	local sizes = {"", "k", "M", "G", "T", "P", "E"}
	local exponent = math.floor(math.log(num,10))
	local group = math.floor(exponent / 3)
	if group > #sizes then
		return string.format("%e", num)
	else
		local divisor = math.pow(10, (group - 1) * 3)
		return string.format("%i%s", num / divisor, sizes[group])
	end
end -- local function formatReadableSIUnit(num)

-- pretty printLog() a table
	local function tprint (tbl, loglevel, indent)
	if not loglevel then loglevel = DEBUG end
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			printLog(formatting, loglevel)
			tprint(v, loglevel, indent+1)
		elseif type(v) == 'boolean' or type(v) == "function" then
			printLog(formatting .. tostring(v), loglevel)
		else
			printLog(formatting .. v, loglevel)
		end
	end
end -- function tprint()

config = {}

-- Save a table into a config file
-- path: path of the file to write
-- tab: table to save
config.save = function(path, tab)
	printLog("Save function called for config for "..path.." EOL")
	assert(path ~= nil, "Path can't be nil")
	assert(type(tab) == "table", "Second parameter must be a table")
	-- Atomic write: write to temp file, then rename to avoid partial writes
	local tmpPath = path .. ".tmp"
	local f = io.open(tmpPath, "w")
	if not f then
		printLog("Failed to open "..tmpPath.." for writing, attempting direct write", ERROR)
		f = io.open(path, "w")
		if not f then
			printLog("Failed to write config file "..path, ERROR)
			return
		end
	end
	local i = 0
	for key, value in pairs(tab) do
		if i ~= 0 then
			f:write("\n")
		end
		f:write("["..key.."]".."\n")
		for key2, value2 in pairs(tab[key]) do
			key2 = stringTrim(key2)
			if (type(value2) == "boolean") then
				value2 = tostring(value2)
			else
				value2 = stringTrim(value2)
			end
			key2 = key2:gsub(";", "\\;")
			key2 = key2:gsub("=", "\\=")
			value2 = value2:gsub(";", "\\;")
			value2 = value2:gsub("=", "\\=")
			f:write(key2.."="..value2.."\n")
		end
		i = i + 1
	end
	f:close()
	-- Rename temp file to final path (atomic on most filesystems)
	fs.delete(path)
	fs.move(tmpPath, path)
end --config.save = function(path, tab)

-- Load a config file
-- path: path of the file to read
config.load = function(path)
	printLog("Load function called for config for "..path.." EOL")
	assert(path ~= nil, "Path can't be nil")
	local f = fs.open(path, "r")
	if f ~= nil then
		printLog("Successfully opened "..path.." for reading EOL")
		local tab = {}
		local line = ""
		local newLine
		local i
		local currentTag = nil
		local found = false
		local pos = 0
		while line ~= nil do
			found = false
			line = line:gsub("\\;", "#_!36!_#") -- to keep \;
			line = line:gsub("\\=", "#_!71!_#") -- to keep \=
			if line ~= "" then
				-- Delete comments
				newLine = line
				line = ""
				for i=1, string.len(newLine) do
					if string.sub(newLine, i, i) ~= ";" then
						line = line..newLine:sub(i, i)
					else
						break
					end
				end
				line = stringTrim(line)
				-- Find tag
				if line:sub(1, 1) == "[" and line:sub(line:len(), line:len()) == "]" then
					currentTag = stringTrim(line:sub(2, line:len()-1))
					tab[currentTag] = {}
					found = true
				end
				-- Find key and values
				if not found and line ~= "" then
					pos = line:find("=")
					if pos == nil then
						printLog("Skipping malformed line in "..path..": "..line, WARN)
						found = true
					else
						line = line:gsub("#_!36!_#", ";")
						line = line:gsub("#_!71!_#", "=")
						tab[currentTag][stringTrim(line:sub(1, pos-1))] = stringTrim(line:sub(pos+1, line:len()))
						found = true
					end
				end
			end
			line = f.readLine()
		end

		f:close()

		return tab
	else
		printLog("Could NOT opened "..path.." for reading! EOL")
		return nil
	end
end --config.load = function(path)



-- round() function from mechaet
local function round(num, places)
	local mult = 10^places
	local addon = nil
	if ((num * mult) < 0) then
		addon = -.5
	else
		addon = .5
	end

	local integer, decimal = math.modf(num*mult+addon)
	local newNum = integer/mult
	printLog("Called round(num="..num..",places="..places..") returns \""..newNum.."\".")
	return newNum
end -- function round(num, places)


local function print(printParams)
	-- Default to xPos=1, yPos=1, and first monitor
	setmetatable(printParams,{__index={xPos=1, yPos=1, monitorIndex=1}})
	local printString, xPos, yPos, monitorIndex =
		printParams[1], -- Required parameter
		printParams[2] or printParams.xPos,
		printParams[3] or printParams.yPos,
		printParams[4] or printParams.monitorIndex

	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in print() is NOT a valid monitor.")
		return -- Invalid monitorIndex
	end

	monitor.setCursorPos(xPos, yPos)
	monitor.write(printString)
end -- function print(printParams)


-- Replaces the one from FC_API (http://pastebin.com/A9hcbZWe) and adding multi-monitor support
local function printCentered(printString, yPos, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in printCentered() is NOT a valid monitor.", ERROR)
		return -- Invalid monitorIndex
	end

	local width, height = monitor.getSize()
	local monitorNameLength = 0

	-- Special changes for title bar
	if yPos == 1 then
		-- Add monitor name to first line
		monitorNameLength = monitorNames[monitorIndex]:len()
		width = width - monitorNameLength -- add a space

		-- Leave room for "offline" and "online" on the right except for overall status display
		if monitorAssignments[monitorNames[monitorIndex]].type ~= "Status" then
			width = width - 7
		end
	end

	monitor.setCursorPos(monitorNameLength + math.ceil((1 + width - printString:len())/2), yPos)
	monitor.write(printString)
end -- function printCentered(printString, yPos, monitorIndex)


-- Print text padded from the left side
-- Clear the left side of the screen
local function printLeft(printString, yPos, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in printLeft() is NOT a valid monitor.", ERROR)
		return -- Invalid monitorIndex
	end

	local gap = 1
	local width = monitor.getSize()

	-- Clear left-half of the monitor

	for curXPos = 1, (width / 2) do
		monitor.setCursorPos(curXPos, yPos)
		monitor.write(" ")
	end

	-- Write our string left-aligned
	monitor.setCursorPos(1+gap, yPos)
	monitor.write(printString)
end


-- Print text padded from the right side
-- Clear the right side of the screen
local function printRight(printString, yPos, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in printRight() is NOT a valid monitor.", ERROR)
		return -- Invalid monitorIndex
	end

	-- Make sure printString is a string
	printString = tostring(printString)

	local gap = 1
	local width = monitor.getSize()

	-- Clear right-half of the monitor
	for curXPos = (width/2), width do
		monitor.setCursorPos(curXPos, yPos)
		monitor.write(" ")
	end

	-- Write our string right-aligned
	monitor.setCursorPos(math.floor(width) - math.ceil(printString:len()+gap), yPos)
	monitor.write(printString)
end


-- Replaces the one from FC_API (http://pastebin.com/A9hcbZWe) and adding multi-monitor support
local function clearMonitor(printString, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	printLog("Called as clearMonitor(printString="..printString..",monitorIndex="..monitorIndex..").")

	if not monitor then
		printLog("monitor["..monitorIndex.."] in clearMonitor(printString="..printString..",monitorIndex="..monitorIndex..") is NOT a valid monitor.", ERROR)
		return -- Invalid monitorIndex
	end

	local gap = 2
	monitor.clear()
	local width, height = monitor.getSize()

	printCentered(printString, 1, monitorIndex)
	monitor.setTextColor(colors.blue)
	print{monitorNames[monitorIndex], 1, 1, monitorIndex}
	monitor.setTextColor(colors.white)

	for i=1, width do
		monitor.setCursorPos(i, gap)
		monitor.write("-")
	end

	monitor.setCursorPos(1, gap+1)
end -- function clearMonitor(printString, monitorIndex)


-- Return a list of all connected (including via wired modems) devices of "deviceType"
local function getDevices(deviceType)
	printLog("Called as getDevices(deviceType="..deviceType..")")

	local deviceName = nil
	local deviceIndex = 1
	local deviceList, deviceNames = {}, {} -- Empty array, which grows as we need
	local peripheralList = peripheral.getNames() -- Get table of connected peripherals

	deviceType = deviceType:lower() -- Make sure we're matching case here

	for peripheralIndex = 1, #peripheralList do
		-- Log every device found
		-- printLog("Found "..peripheral.getType(peripheralList[peripheralIndex]).."["..peripheralIndex.."] attached as \""..peripheralList[peripheralIndex].."\".")
		if (string.lower(peripheral.getType(peripheralList[peripheralIndex])) == deviceType) then
			-- Log devices found which match deviceType and which device index we give them
			printLog("Found "..peripheral.getType(peripheralList[peripheralIndex]).."["..peripheralIndex.."] as index \"["..deviceIndex.."]\" attached as \""..peripheralList[peripheralIndex].."\".")
			write("Found "..peripheral.getType(peripheralList[peripheralIndex]).."["..peripheralIndex.."] as index \"["..deviceIndex.."]\" attached as \""..peripheralList[peripheralIndex].."\".\n")
			deviceNames[deviceIndex] = peripheralList[peripheralIndex]
			deviceList[deviceIndex] = peripheral.wrap(peripheralList[peripheralIndex])
			deviceIndex = deviceIndex + 1
		end
	end -- for peripheralIndex = 1, #peripheralList do

	return deviceList, deviceNames
end -- function getDevices(deviceType)

-- Draw a line across the entire x-axis
local function drawLine(yPos, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in drawLine() is NOT a valid monitor.")
		return -- Invalid monitorIndex
	end

	local width, height = monitor.getSize()

	for i=1, width do
		monitor.setCursorPos(i, yPos)
		monitor.write("-")
	end
end -- function drawLine(yPos,monitorIndex)


-- Display a solid bar of specified color
local function drawBar(startXPos, startYPos, endXPos, endYPos, color, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in drawBar() is NOT a valid monitor.")
		return -- Invalid monitorIndex
	end

	-- PaintUtils only outputs to term., not monitor.
	-- See http://www.computercraft.info/forums2/index.php?/topic/15540-paintutils-on-a-monitor/
	term.redirect(monitor)
	paintutils.drawLine(startXPos, startYPos, endXPos, endYPos, color)
	monitor.setBackgroundColor(colors.black) -- PaintUtils doesn't restore the color
	termRestore()
end -- function drawBar(startXPos, startYPos,endXPos,endYPos,color,monitorIndex)


-- Display single pixel color
local function drawPixel(xPos, yPos, color, monitorIndex)
	local monitor = nil
	monitor = monitorList[monitorIndex]

	if not monitor then
		printLog("monitor["..monitorIndex.."] in drawPixel() is NOT a valid monitor.")
		return -- Invalid monitorIndex
	end

	-- PaintUtils only outputs to term., not monitor.
	-- See http://www.computercraft.info/forums2/index.php?/topic/15540-paintutils-on-a-monitor/
	term.redirect(monitor)
	paintutils.drawPixel(xPos, yPos, color)
	monitor.setBackgroundColor(colors.black) -- PaintUtils doesn't restore the color
	termRestore()
end -- function drawPixel(xPos, yPos, color, monitorIndex)

local function saveMonitorAssignments()
	local assignments = {}
	for monitor, data in pairs(monitorAssignments) do
		local name = nil
		if (data.type == "Reactor") then
			name = data.reactorName
		elseif (data.type == "Turbine") then
			name = data.turbineName
		else
			name = data.type
		end
		assignments[monitor] = name
	end
	config.save(monitorOptionFileName, {Monitors = assignments})
end

UI = {
	monitorIndex = 1,
	reactorIndex = 1,
	turbineIndex = 1
}

UI.handlePossibleClick = function(self)
	local monitorData = monitorAssignments[sideClick]
	if monitorData == nil then
		printLog("UI.handlePossibleClick(): "..sideClick.." is unassigned, can't handle click", WARN)
		return
	end

	self.monitorIndex = monitorData.index
	local width, height = monitorList[self.monitorIndex].getSize()
	-- All the last line are belong to us
	if (yClick == height) then
		if (monitorData.type == "Reactor") then
			if (xClick == 1) then
				self:selectPrevReactor()
			elseif (xClick == width) then
				self:selectNextReactor()
			elseif (3 <= xClick and xClick <= width - 2) then
				if (#turbineList > 0) then
					self:selectTurbine()
				else
					self:selectStatus()
				end
			end
		elseif (monitorData.type == "Turbine") then
			if (xClick == 1) then
				self:selectPrevTurbine()
			elseif (xClick == width) then
				self:selectNextTurbine()
			elseif (3 <= xClick and xClick <= width - 2) then
				self:selectStatus()
			end
		elseif (monitorData.type == "Status") then
			if (xClick == 1) then
				if (#turbineList > 0) then
					self.turbineIndex = #turbineList
					self:selectTurbine()
				else
					self.reactorIndex = 1
					self:selectReactor()
				end
			elseif (xClick == width) then
				self.reactorIndex = 1
				self:selectReactor()
			elseif (3 <= xClick and xClick <= width - 2) then
				self:selectReactor()
			end
		else
			self:selectStatus()
		end
		-- Yes, that means we're skipping Debug. I figure everyone who wants that is
		-- bound to use the console key commands anyway, and that way we don't have
		-- it interfere with regular use.

		sideClick, xClick, yClick = 0, 0, 0
	else
		if (monitorData.type == "Turbine") then
			self:handleTurbineMonitorClick(monitorData.turbineIndex, monitorData.index)
		elseif (monitorData.type == "Reactor") then
			self:handleReactorMonitorClick(monitorData.reactorIndex, monitorData.index)
		end
	end
end -- UI.handlePossibleClick()

UI.logChange = function(self, messageText)
	printLog("UI: "..messageText)
	termRestore()
	write(messageText.."\n")
end

UI.selectNextMonitor = function(self)
	self.monitorIndex = self.monitorIndex + 1
	if self.monitorIndex > #monitorList then
		self.monitorIndex = 1
	end
	local messageText = "Selected monitor "..monitorNames[self.monitorIndex]
	self:logChange(messageText)
end -- UI.selectNextMonitor()


UI.selectReactor = function(self)
	monitorAssignments[monitorNames[self.monitorIndex]] = {type="Reactor", index=self.monitorIndex, reactorName=reactorNames[self.reactorIndex], reactorIndex=self.reactorIndex}
	saveMonitorAssignments()
	local messageText = "Selected reactor "..reactorNames[self.reactorIndex].." for display on "..monitorNames[self.monitorIndex]
	self:logChange(messageText)
end -- UI.selectReactor()

UI.selectPrevReactor = function(self)
	if self.reactorIndex <= 1 then
		self.reactorIndex = #reactorList
		self:selectStatus()
	else
		self.reactorIndex = self.reactorIndex - 1
		self:selectReactor()
	end
end -- UI.selectPrevReactor()

UI.selectNextReactor = function(self)
	if self.reactorIndex >= #reactorList then
		self.reactorIndex = 1
		if #turbineList > 0 then
			self.turbineIndex = 1
			self:selectTurbine()
		else
			self:selectStatus()
		end
	else
		self.reactorIndex = self.reactorIndex + 1
		self:selectReactor()
	end
end -- UI.selectNextReactor()


UI.selectTurbine = function(self)
	monitorAssignments[monitorNames[self.monitorIndex]] = {type="Turbine", index=self.monitorIndex, turbineName=turbineNames[self.turbineIndex], turbineIndex=self.turbineIndex}
	saveMonitorAssignments()
	local messageText = "Selected turbine "..turbineNames[self.turbineIndex].." for display on "..monitorNames[self.monitorIndex]
	self:logChange(messageText)
end -- UI.selectTurbine()

UI.selectPrevTurbine = function
