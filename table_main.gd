extends Node3D
var show
var nameN
@onready var text_hand: RichTextLabel = $RichTextLabel

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		show2()
		print("usedCards:",CardDecks.usedDeck.arrayOfCards)
		print("withdrawCards:",CardDecks.withDrawDeck.arrayOfCards)
		

func add_player(player):
	call_deferred("add_child",player)

func show2():
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

func izprati(plF:int,card):
	print("izprati",self.name)
	rpc("izprati_rpc",plF,card)
	text_hand.text=str(CardDecks.hands[plF].arrayOfCards)

@rpc("any_peer","call_remote","reliable",3)
func izprati_rpc(plF:int,card):
	print(nameN,plF)
	if nameN==str(plF):
		CardDecks.hands[plF].addUpCard(card)
		var strH=str(CardDecks.hands[plF].arrayOfCards)
		text_hand.text=strH
		print(plF,text_hand.text)
