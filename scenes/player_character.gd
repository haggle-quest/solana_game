extends Node2D


# Here we're communicating choices made in the offer slider to the player offer
# label. We're not sure if this is the best way to do it / should we use a 
# getset method?
var current_offer

onready var confirm_offer = get_parent().get_node("UI/confirm_offer")
onready var displayed_offer = $player_offer_label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func make_offer(offers):
#	print("should be yielding")
#	yield(get_tree().create_timer(10.0), "timeout")
#	print("finished yielding")
	yield(confirm_offer, "pressed")
	return(current_offer)
#	print("correctly yielded")
#	return 1

func close_deal(offer, agent_id, quantity=1):
	print("closed deal")
	print("Reduced money, increased items quantity")
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_confirm_offer_pressed():
	pass # Replace with function body.


func _on_offer_slider_value_changed(value):
	# TODO not sure why the offer slider is returning a real number instead 
	# of an int?
	current_offer = int(value)
	if value == 0:
		displayed_offer.text = "Reject"
	elif value == 21:
		displayed_offer.text = "Accept"
	else:
		displayed_offer.text = str(value)

