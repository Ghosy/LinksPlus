require("ts3defs")
require("ts3errors")

lastURL = " "
myOS = " "
local fileHandle = io.open("/home/")
if fileHandle ~= nil then
	io.close(fileHandle)
	myOS = "Linux"
else
	if string.sub(package.config, 1, 1) == "\\" then
		myOS = "Windows"
	else
		fileHandle = io.open("/Applications/")
		if fileHandle ~= nil then
			io.close(fileHandle)
			myOS = "Mac"
		end
	end
end
if myOS == " " then
	ts3.printMessageToCurrentTab("OS could not be determined")
end

function test(serverConnectionHandlerID)
	local message = " "
	local myClientID = ts3.getClientID(serverConnectionHandlerID)
	local myChannelID = ts3.getChannelOfClient(serverConnectionHandlerID, myClientID)
	local clipboard

	if myOS == "Windows" then
		clipboard = io.popen("clipboard.exe")
	elseif myOS == "Linux" then
		clipboard = io.popen("echo $(xclip -o)")
	elseif myOS == "Mac" then
		clipboard = io.popen("echo $(pbpaste)")
	end

	if clipboard ~= nil then
		message = string.sub(clipboard:read("*a"), 1, -2)
	else
		ts3.printMessageToCurrentTab("Nothing was found on your clipboard")
	end

	if string.sub(message, 1, 7) == "http://" or string.sub(message, 1, 8) == "https://" then
		message = "[url]"..message.."[/url]"
	end

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, message, myChannelID)
end

function receiveMsg(message)
	if string.find(message, "%[[uU][rR][lL]%]") ~= nil and string.find(message, "%[/[uU][rR][lL]%]") ~= nil then
		lastURL = string.match(message, '%[[uU][rR][lL]%].-%[/[uU][rR][lL]%]')
		lastURL = string.sub(lastURL, 6, -7)
		return lastURL
	end
end

function openLastURL()
	if myOS == "Linux" then
		os.execute("xdg-open "..lastURL)
	elseif myOS == "Windows" then
		os.execute("start "..lastURL)
	elseif myOS == "Mac" then
		os.execute("open "..lastURL)
	end
end

LinksPlus = {
	test = test,
	receiveMsg = receiveMsg,
	openLastURL = openLastURL
}
