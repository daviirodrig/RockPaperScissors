extends Node

var socket: WebSocketPeer = WebSocketPeer.new()
var connected: bool
var channel: String

signal chat_message(message, tags)


func _process(_delta: float) -> void:
	socket.poll()
	var state := socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if !connected:
			auth()
			connected = true
		while socket.get_available_packet_count():
			data_received(socket.get_packet())
	elif state == WebSocketPeer.STATE_CLOSING:
		print("closing")
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		print("closed")
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false)  # Stop processing.


func data_received(data: PackedByteArray) -> void:
	var messages: PackedStringArray = data.get_string_from_utf8().strip_edges(false).split("\r\n")
	var tags = {}
	for message in messages:
		if message.begins_with("@"):
			var msg: PackedStringArray = message.split(" ", false, 1)
			message = msg[1]
			for tag in msg[0].split(";"):
				var pair = tag.split("=")
				tags[pair[0]] = pair[1]
		if OS.is_debug_build():
			print("> " + message)
		handle_message(message, tags)


func handle_message(message: String, tags: Dictionary) -> void:
	if message == "PING :tmi.twitch.tv":
		socket.send_text("PONG :tmi.twitch.tv")
		return
	var msg: PackedStringArray = message.split(" ", true, 3)
	match msg[1]:
		"NOTICE":
			var info: String = msg[3].right(-1)
			if info == "Login authentication failed" || info == "Login unsuccessful":
				print_debug("Authentication failed.")
			elif info == "You don't have permission to perform that action":
				print_debug("No permission. Check if access token is still valid. Aborting.")
				set_process(false)
		"001":
			print_debug("Authentication successful.")
		"PRIVMSG":
			chat_message.emit(message, tags)


func auth() -> void:
	var n = floor((randf() * 80000) + 1000)
	var botname = "justinfan%s" % n
	var token = "."  # anonymous login, this can be anything
	var ch = "#" + channel.to_lower()
	socket.send_text("PASS oauth:%s" % token)
	socket.send_text("NICK " + botname)
	socket.send_text("JOIN " + ch)


func _ready() -> void:
	socket.connect_to_url("wss://irc-ws.chat.twitch.tv:443")
	self.connect("chat_message", Callable(self, "on_chat"))


func on_chat(message, tags) -> void:
	print("%s: %s" % [message, tags])
