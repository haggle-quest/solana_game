extends Node2D


# Here we're communicating choices made in the offer slider to the player offer
# label. We're not sure if this is the best way to do it / should we use a 
# getset method?
var current_offer

var total_gold setget total_gold_set
var max_items setget max_items_set
var total_items = 0

var agent_name = "Player"

# Seller always goes first
const SELLER_ID = 0
const BUYER_ID = 1

onready var player_action = get_parent().get_node("UI/player_action")
onready var make_offer_button = get_parent().get_node("UI/player_action/make_offer")
onready var reject_offer_button = get_parent().get_node("UI/player_action/reject_offer")
onready var accept_offer_button = get_parent().get_node("UI/player_action/accept_offer")

onready var total_gold_label = get_parent().get_node("UI/Panel/HBoxContainer/Total_gold")
onready var total_items_label = get_parent().get_node("UI/Panel/HBoxContainer/Total_items")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func total_gold_set(value):
	total_gold = value
	total_gold_label.text = "Gold:\n\r" + str(value)

func max_items_set(value):
	max_items = value
	total_items_label.text = "Items:\n\r%s/%s" % [total_items, value]

# Called when the node enters the scene tree for the first time.
func make_offer(offers, agent_id):
	make_offer_button.disabled = false
	reject_offer_button.disabled = false
	accept_offer_button.disabled = false
	if len(offers) == 0:
		reject_offer_button.disabled = true
		accept_offer_button.disabled = true
	if len(offers) >= 3:
		make_offer_button.disabled = true
	var this_action = yield(player_action, "offered")
	# Resent buttons
	make_offer_button.disabled = true
	reject_offer_button.disabled = true
	accept_offer_button.disabled = true

	return(this_action)
#	print("correctly yielded")
#	return 1

func close_deal(offer, agent_id, quantity=1):
	print("closed deal")
	print("Reduced money, increased items quantity")
	print("Total_gold: ", total_gold, "Offer: ", offer)
	# Unfortunately you can't call setget functions internally
	if agent_id == BUYER_ID:
		total_gold -= offer
		total_gold_label.text = "Gold:\n\r" + str(total_gold)
		total_items += 1
		total_items_label.text = "Items:\n\r%s/%s" % [total_items, max_items]
	elif agent_id == SELLER_ID:
		total_gold += offer
		total_gold_label.text = "Gold:\n\r" + str(total_gold)
		total_items -= 1
		total_items_label.text = "Items:\n\r%s/%s" % [total_items, max_items]


func _on_offer_slider_value_changed(value):
	# TODO not sure why the offer slider is returning a real number instead 
	# of an int?
	current_offer = int(value)


func _on_player_action_player_offered():
	pass # Replace with function body.
