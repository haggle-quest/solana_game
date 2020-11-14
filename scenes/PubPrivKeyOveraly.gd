extends Control

#onready var keys = get_node("/root/Load_addresses")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var keypair_file_path = "user://keypair.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	var keypair_file = File.new()
	# TODO wait until it does exist
	keypair_file.open(keypair_file_path, File.READ)
	var keypair = parse_json(keypair_file.get_as_text())
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Private_key_input.text = keypair['private_key']
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Public_key_input.text = keypair['public_key']
	
#	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Private_key_label.text = keys.private_key



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
