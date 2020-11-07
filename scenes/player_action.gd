extends GridContainer

onready var Make_offer = $make_offer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal offered


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_reject_offer_pressed():
	emit_signal("offered", 22)
	pass # Replace with function body.


func _on_make_offer_pressed():
	var amount = Make_offer.text.split(" ")[1]
	emit_signal("offered", int(amount))
	pass # Replace with function body.


func _on_accept_offer_pressed():
	emit_signal("offered", 21)
	pass # Replace with function body.
