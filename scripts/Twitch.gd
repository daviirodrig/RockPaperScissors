extends Gift

var channel

func _ready() -> void:
	var n = floor((randf() * 80000) + 1000)
	var botname = "justinfan%s" % n
	var token = "." # anonymous login, this can be anything

	connect_to_twitch()
	yield(self, "twitch_connected")

	authenticate_oauth(botname, token)
	if yield(self, "login_attempt") == false:
		print("Invalid username or token.")
		return
	join_channel(channel)

	connect("chat_message", self, "chat_message")


func chat_message(sender: SenderData, message) -> void:
	print("%s: %s" % [sender.user, message])
