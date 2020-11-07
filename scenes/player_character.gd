extends Node2D


# Here we're communicating choices made in the offer slider to the player offer
# label. We're not sure if this is the best way to do it / should we use a 
# getset method?
var current_offer

onready var player_action = get_parent().get_node("UI/player_action")
onready var displayed_offer = $player_offer_label
onready var make_offer_button = get_parent().get_node("UI/player_action/make_offer")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func make_offer(offers):
#	print("should be yielding")
#	yield(get_tree().create_timer(10.0), "timeout")
#	print("finished yielding")
	if len(offers) >= 3:
		make_offer_button.disabled = true
	var this_action = yield(player_action, "offered")
	make_offer_button.disabled = false
	return(this_action)
#	print("correctly yielded")
#	return 1

func close_deal(offer, agent_id, quantity=1):
	print("closed deal")
	print("Reduced money, increased items quantity")
	pass


func _on_offer_slider_value_changed(value):
	# TODO not sure why the offer slider is returning a real number instead 
	# of an int?
	current_offer = int(value)
#	if value == 0:
#		displayed_offer.text = "Reject"
#	elif value == 21:
#		displayed_offer.text = "Accept"
#	else:
#		displayed_offer.text = str(value)


func _on_player_action_player_offered():
	pass # Replace with function body.
