extends Node3D
var show
var nameNMultiplayerSpawner
@onready var text_hand: RichTextLabel = $RichTextLabel
var multiplObj
var playerPosition=[Vector3(0,1.2,0.9),Vector3(3.7,1.5,-2.98),Vector3(0.16,1.2,-6.13)]

	

func nameN()->int:
	return multiplObj.get_peer_name(multiplayer.get_unique_id());

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		show2()
		print("usedCards:",CardDecks.usedDeck.arrayOfCards)
		print("withdrawCards:",CardDecks.withDrawDeck.arrayOfCards)

func add_player(player):
	player.position=playerPosition[int(player.name)]
	print(multiplObj.arr)
	print("nm:",player.name,nameN())
	player.usb=int(player.name)==nameN()
	call_deferred("add_child",player)

func show2():
	if multiplObj:
		print(multiplObj.arr)
	#Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	$Canvas.show()
	show=true
	Engine.time_scale=0

func hide2():
	#Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	$Canvas.hide()
	show=false
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
	print(multiplObj.arr)
	rpc_id(multiplObj.arr[plF],"izprati_rpc",plF,card)


@rpc("any_peer","call_remote","reliable",3)
func izprati_rpc(plF:int,card):
	#print("za",nameN,plF)
	if nameN()==plF:
		CardDecks.hands[plF].addUpCard(card)
		var strH=str(CardDecks.hands[plF].arrayOfCards)
		text_hand.text=strH
		#print(plF,text_hand.text)
