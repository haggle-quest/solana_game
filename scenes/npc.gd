extends Node2D

var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var internal_value
var current_offer

var model_weights

var agent_name = "NPC"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_npc():
	rng.randomize()
	# We're setting max 16 because it becomes more unstable at higher values
	internal_value = rng.randi_range(1,17)


func make_offer(offers):
	var information_state
#	print("Offerings: ", internal_value, offers.join(""))
	# A very cheesy hack to make sure the yield function in the parent function
	# has time to wait until the signal is emitted
	yield(get_tree().create_timer(0.25), "timeout")
#	print(offers)
	information_state = create_information_state(internal_value, offers)
	print(information_state)
	print(model_weights[information_state])
	var these_weights = model_weights[information_state]
	current_offer = get_weighted_random_choice(these_weights)
#	current_offer = internal_value
	return(current_offer)
#	return 1

func close_deal(offer, agent_id, quantity=1):
	pass

func get_weighted_random_choice(weights):
	"""Kind of a hacky solution to get weighted probability for action choices """
	var actions = weights.keys()
	var probs = weights.values()
	var weighted_sums = []
	for prob in probs:
		if not weighted_sums:
			weighted_sums.append(prob)
			continue
		weighted_sums.append(prob + weighted_sums.back())
	print(actions)
	print(weighted_sums)
	var random_choice = rng.randi_range(0, weighted_sums.max())
	var chosen_sum
	for weighted_sum in weighted_sums:
		if random_choice < weighted_sum:
			chosen_sum = weighted_sum
			break
	print("random_choice: ", random_choice)
	print("index in weighted_sums: ", weighted_sums.find(chosen_sum))
	var choice_idx = weighted_sums.find(chosen_sum)
	return(int(actions[choice_idx]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func create_information_state(internal_value, offers):
	var this_information_state
	if len(offers) == 0:
		this_information_state = str(internal_value)
	elif len(offers) == 1:
		this_information_state = str(internal_value) + ' Ask_' + str(offers[0])
	elif len(offers) == 2:
		this_information_state = str(internal_value) + ' Ask_' + str(offers[0]) +  ' Bid_' + str(offers[1])
	elif len(offers) == 3:
		this_information_state = str(internal_value) + ' Ask_' + str(offers[0]) +  ' Bid_' + str(offers[1])  + ' Ask_' + str(offers[2])
	else:
		assert(this_information_state, "Error, not implemented")
	return(this_information_state)
