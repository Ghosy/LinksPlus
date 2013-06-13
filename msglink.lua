require("ts3defs")
require("ts3errors")

function test(serverConnectionHandlerID)
	local message = "[url]http://test.com/[/url]" 
	local myClientID = ts3.getClientID(serverConnectionHandlerID)
	local myChannelID = ts3.getChannelOfClient(serverConnectionHandlerID, myClientID)
	local myOS = " "
	local fileHandle = io.open("/etc/")
	if fileHandle ~= nil then
		io.close(fileHandle)
		myOS = "Linux"
	else
		fileHandle = io.open("C:/Windows/")
		if fileHandle ~= nil then
			io.close(fileHandle)
			myOS = "Windows"
		else
			fileHandle = io.open("/home/")
			if fileHandle ~= nil then
				io.close(fileHandle)
				myOS = "Mac"
			end
		end
	end

	local file

	if myOS == "Windows" then
		os.execute("clipboard.exe temp")
	elseif myOS == "Linux" then
		file = io.popen("echo $(xclip -o)")
		
	elseif myOS == "Mac" then
		file = io.popen("echo 'pbpaste'")
	end

	message = string.sub(file:read("*a"), 1, -2)
	message = "[url]"..message.."[/url]"

	ts3.requestSendChannelTextMsg(serverConnectionHandlerID, message, myChannelID)
end

linkplus = {
	test = test
}
