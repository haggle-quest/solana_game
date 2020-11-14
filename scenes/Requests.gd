extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	var error = $HTTPRequest.request("http://localhost:4000/fetch-votes")
	if error != OK:
		print("An error occurred in the HTTP request.")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Printing JSON result")
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
