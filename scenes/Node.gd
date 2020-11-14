extends Node

var public_key
var private_key
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var keypair_file_path = "user://keypair.json"
var voter_info_file_path = "user://voter_info.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	var error = $HTTPRequest.request("https://solana-roguelike-vote-server.herokuapp.com/create-account")
	if error != OK:
		print("An error occurred in the HTTP request.")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Printing JSON result")
	var json = JSON.parse(body.get_string_from_utf8())
	assign_variables(json.result)
	
	# 
	var main = get_tree().current_scene
	var main_menu = main.find_node("MainMenu")
	main_menu.on_create_account_finished()
	pass # Replace with function body.

func assign_variables(json):
	print(json)
	public_key = json['createdMintAccount']
	private_key = json['readableAccount']['privateKey']
	var keypair = {"public_key": public_key, "private_key": private_key}
	var save_keypair = File.new()
	save_keypair.open(keypair_file_path, File.WRITE)
	save_keypair.store_line(to_json(keypair))
	save_keypair.close()
	
	var save_voter_info = File.new()
	save_voter_info.open(voter_info_file_path, File.WRITE)
	save_voter_info.store_line(to_json(json))
	save_voter_info.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
