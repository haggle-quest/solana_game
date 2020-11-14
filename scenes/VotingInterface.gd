extends Node

const Issue = preload("res://buttons/display_vote_template.tscn")

var voter_info_file_path = "user://voter_info.json"

onready var cute_character = $Control/VBoxContainer/cute_character
onready var list_of_issues = $Control/VBoxContainer/ScrollContainer/list_of_issues
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var available_votes = $Control/VBoxContainer/VotingStatsPanel/VotingStatsHbox/AvailableVotes


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	var error = $HTTPRequest.request("https://solana-roguelike-vote-server.herokuapp.com/fetch-votes")
	if error != OK:
		print("An error occurred in the HTTP request.")
#	var main = get_tree().current_scene
#	var load_addresses = main.find_node("Load_addresses")
#	print(LoadAddresses.public_key)
	available_votes.text = "AVAILABLE VOTES %s" % LoadAddresses.global_available_votes


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Printing JSON result")
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	var output = json.result
#	if "tokenBalance" not in json.result :
	# Check if typeOf TYPE_ARRAY = 21
	if typeof(output) == TYPE_ARRAY:
		stop_loading()
		parse_and_load_issues(json.result)
	else:
		# fetch votes if we got back a response from the burn votes thing
		print("this should be the remaining votes: ", output)
		LoadAddresses.global_available_votes = output['tokenBalance']
		available_votes.text = "AVAILABLE VOTES %s" % LoadAddresses.global_available_votes
		var error = $HTTPRequest.request("https://solana-roguelike-vote-server.herokuapp.com/fetch-votes")
		if error != OK:
			print("An error occurred in the HTTP request.")
	pass # Replace with function body.

func stop_loading():
	cute_character.stop_bouncing_anim()


func parse_and_load_issues(issues_json):
	# Make sure that node is empty first
	for button_container in list_of_issues.get_children():
		button_container.queue_free()
	for raw_issue in issues_json:
		var this_issue = Issue.instance()
		list_of_issues.add_child(this_issue)
		this_issue.issue_title = raw_issue['title']
		this_issue.num_votes = raw_issue['numberOfVotes']
		this_issue.issue_number = raw_issue['issueId']
		this_issue.connect("voted", self, "on_vote_Button_pressed", [this_issue.issue_number])
		pass
	pass

func on_vote_Button_pressed(value):

	# Disable all of the buttons
	for button_container in list_of_issues.get_children():
		button_container.find_node("vote_button").disabled = true
	if LoadAddresses.global_available_votes == "0":
		available_votes.text = "Oh no, you're out of votes!"
		return
	cute_character.play_bouncing_anim()
	
#	var voter_info_file = File.new()
	# TODO wait until it does exist
#	voter_info_file.open(voter_info_file_path, File.READ)
	# We have to load instead from a global variable because internet cookies >:0
#	var voter_info = parse_json(voter_info_file.get_as_text())
	var voter_info = LoadAddresses.global_voter_info
	voter_info['github'] = value
	var body = JSON.print(voter_info)
	var headers = ["Content-Type: application/json"]
	print(body)
	var error = $HTTPRequest.request("https://solana-roguelike-vote-server.herokuapp.com/burn-token", headers, true, HTTPClient.METHOD_POST, body)
	print(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
