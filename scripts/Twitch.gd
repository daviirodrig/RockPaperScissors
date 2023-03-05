extends Gift

var channel

func _ready() -> void:
	var n = floor((randf() * 80000) + 1000)
	var botname = "justinfan%s" % n
	var token = "." # anonymous login, this can be anything
	await connect_to_irc()
	await self.twitch_connected

	authenticate_oauth(botname, token)
	if await self.login_attempt == false:
		print("Invalid username or token.")
		return
	join_channel(channel)

	connect("chat_message",Callable(self,"chat_message"))


func on_chat(sender: SenderData, message: String) -> void:
	print("%s: %s" % [sender.user, message])
