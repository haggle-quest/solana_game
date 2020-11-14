extends Node


#onready var NPC_AI_position = $NPC_AI_position
onready var player = $player_character
#var NPC_AI_scene = preload("res://scenes/NPC_AI.tscn")
onready var npc_ai = $npc

onready var offers_label = $UI/Offers
onready var remaining_npcs = $UI/Panel/HBoxContainer/Remaining_npcs
onready var offer_slider = $UI/offer_slider

export var player_starting_gold := 200
export var player_max_items := 10

# Saved weights for AI
const SELLER_MODEL_FILE_NAME = "res://cfr_plus_new_payoffs_2000.json"
const BUYER_MODEL_FILE_NAME = "res://cfr_plus_buyers_payoffs_changed_2000.json"

var agents
# Seller always goes first
const SELLER_ID = 0
const BUYER_ID = 1

func load_model_from_file(model_file_name):
	var model_file = File.new()
	model_file.open(model_file_name, File.READ)
	var model_weights = parse_json(model_file.get_as_text())
	print(model_weights['1 Ask_10'])
	print(model_weights['1 Ask_10'].keys())
	print(model_weights['1 Ask_10'].values())
	return model_weights

func _ready():
	yield(player_buying_phase(), "completed")
	print("player buying phase completed")
	yield(player_selling_phase(), "completed")

func player_selling_phase():
			### Init NPC
	# Only need to load and add weights once
	npc_ai.agent_name = "NPC Buyer"
	# clear the previous models weights, maybe this will stop it from breaking?
	npc_ai.model_weights = {}
	npc_ai.model_weights = load_model_from_file(BUYER_MODEL_FILE_NAME)
	randomize()
	var npc_internal_values = range(1,21)
	npc_internal_values.shuffle()
	print("NPC Buyer order: ", npc_internal_values)
	### Init Player
	# Player gold is starting out in debt
	offer_slider.is_player_selling = true
	offer_slider.min_value = 20
	offer_slider.max_value = 39
#	player.total_gold = player.total_gold - player_starting_gold
#	player.max_items = player_max_items
	# Seller goes first
	agents = [player, npc_ai]
	# TODO make this generalizable for both buying and selling
	var num_sellers = len(npc_internal_values)
	for internal_value in npc_internal_values:
		num_sellers -= 1
		remaining_npcs.text = "Remaining\n\rBuyers:\n\r%s" % num_sellers
		print("New NPC")
		npc_ai.internal_value = internal_value
		yield(start_negotiation(agents), "completed")
		if player.total_items <= 0:
			return

func player_buying_phase():
	### Init NPC
	# Only need to load and add weights once
	npc_ai.agent_name = "NPC Seller"
	npc_ai.model_weights = load_model_from_file(SELLER_MODEL_FILE_NAME)
	randomize()
	var npc_internal_values = range(1,21)
	npc_internal_values.shuffle()
	print("NPC Seller order: ", npc_internal_values)
	### Init Player
	offer_slider.is_player_selling = false
	player.total_gold = player_starting_gold
	player.max_items = player_max_items
	# Seller goes first
	agents = [npc_ai, player]
	# TODO make this generalizable for both buying and selling
	var num_sellers = len(npc_internal_values)
	for internal_value in npc_internal_values:
		num_sellers -= 1
		remaining_npcs.text = "Remaining\n\rSellers:\n\r%s" % num_sellers
		print("New NPC")
		npc_ai.internal_value = internal_value
		yield(start_negotiation(agents), "completed")
		if player.total_items >= player_max_items:
			return

func start_negotiation(agents):
	var offers := []
	var this_offer
	var this_actor_id = 0
	var num_turns = 0
	while num_turns < 4:
#		yield(get_tree().create_timer(2.0), "timeout")
		
		this_offer = yield(agents[this_actor_id].make_offer(offers, this_actor_id), "completed")
		print("Offer: ", this_offer)
		if this_offer == 22:
			offers_label.text = offers_label.text + "\n\rRejected >:0"
			break
		elif this_offer == 21:
			# Deal accepted
			offers_label.text = offers_label.text + "\n\rAccepted :)"
			agents[SELLER_ID].close_deal(offers.back(), SELLER_ID)
			agents[BUYER_ID].close_deal(offers.back(), BUYER_ID)
			break
		# Only add an offer to the list if it's not accept or reject
		offers.append(this_offer)
		var offers_text = get_offers_text(offers, agents)
		if this_actor_id == SELLER_ID:
			yield(get_tree().create_timer(0.3), "timeout")
		offers_label.text = offers_text
		num_turns += 1
		this_actor_id = (this_actor_id + 1) % 2
#		print("Value of this: ", this)
	yield(get_tree().create_timer(0.4), "timeout")
	offers_label.text = ""


func get_offers_text(offers, agents):
	var out_text
	
	if len(offers) >= 1:
		out_text = "%s Asked For: %s" %[agents[SELLER_ID].agent_name, offers[0]]
	if len(offers) >= 2:
		out_text += "\n\r%s Offered: %s" % [agents[BUYER_ID].agent_name, offers[1]]
	if len(offers) >= 3:
		out_text += "\n\r%s Countered With: %s" % [agents[SELLER_ID].agent_name, offers[2]]
	return out_text
