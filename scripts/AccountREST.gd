extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequestHandler.connect("request_completed", self, "_on_request_completed")


func _on_HTTPRequestHandler_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result.message)


func _on_Button_pressed():
	$HTTPRequestHandler.request("https://v7arp12jej.execute-api.us-east-1.amazonaws.com/alpha/helloworld?name=John&city=Seattle")
