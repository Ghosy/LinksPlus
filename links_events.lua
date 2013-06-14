local function onTextMessageEvent(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
	receiveMsg(message)
	return 0
end

links_events = {
onTextMessageEvent = onTextMessageEvent
}
