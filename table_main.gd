extends Node3D
var showVr:=false
var nameNMultiplayerSpawner
@onready var text_hand: RichTextLabel = $RichTextLabel
var multiplObj
var playerPosition=[Vector3(0,1.2,0.9),Vector3(3.7,1.5,-2.98),Vector3(0.16,1.2,-6.13)]


func nameN()->int:
	print(multiplObj.get_peer_name(multiplayer.multiplayer_peer.get_unique_id()),multiplayer.multiplayer_peer.get_unique_id())
	return multiplObj.get_peer_name(multiplayer.multiplayer_peer.get_unique_id());

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		show2()
		print("usedCards:",CardDecks.usedDeck.arrayOfCards)
		print("withdrawCards:",CardDecks.withDrawDeck.arrayOfCards)

func add_player(player):
	player.position=playerPosition[int(player.name)]
	print(multiplObj.arr)
	print("nm:",player.name,nameN())
	if int(player.name)==nameN():
		player.usb=1
	call_deferred("add_child",player)

func show2():
	if multiplObj:
		print(multiplObj.arr)
	#Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	$Canvas.show()
	showVr=true
	Engine.time_scale=0

func hide2():
	#Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	$Canvas.hide()
	showVr=false
	Engine.time_scale=1

func _on_resume_button_down() -> void:
	hide2()

func _on_quit_button_down() -> void:
	$"../".exit_game(name.to_int())
	get_tree().quit()

func opravi_host():
	text_hand.text=str(CardDecks.hands[nameN()].arrayOfCards)
	var strH=str(CardDecks.hands[nameN()].arrayOfCards)
	text_hand.text=strH

func izprati(plF:int,card):
	#print("izprati",self.name)
	rpc_id(multiplObj.arr[plF],"izprati_rpc",plF,card)


@rpc("any_peer","call_remote","reliable",3)
func izprati_rpc(plF:int,card):
	#print("za",nameN,plF)
	if nameN()==plF:
		CardDecks.hands[plF].addUpCard(card)
		var strH=str(CardDecks.hands[plF].arrayOfCards)
		text_hand.text=strH
		#print(plF,text_hand.text)


func _on_end_turn_pressed() -> void:
	for i in get_child_count():
		if get_child(i).name==str(nameN()):
			get_child(i).end_turn()

func start():
	for i in get_child_count():
		if get_child(i).name==str(nameN()):
			get_child(i).start_game()
